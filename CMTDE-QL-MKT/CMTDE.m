function data_CMTDE=CMTDE(Tasks,pop_M,gen,p_il,p_cr,F,B)
   
    clc    
%     tic       
   
    no_of_tasks=length(Tasks);
    if no_of_tasks <= 1
        error('At least 2 tasks required for CMTDE');
    end
    D=zeros(1,no_of_tasks);
    for i=1:no_of_tasks
        D(i)=Tasks(i).dims;
    end
    D_multitask=max(D);
    %pop=no_of_tasks*pop_M;%ͳһ�����ռ��С

    options = optimoptions(@fminunc,'Display','off','Algorithm','quasi-newton','MaxIter',2);  
    EvBestFitness = zeros(no_of_tasks,gen); %ÿһ��ÿ������ĸ��������Ӧ��
    EvBestobj= zeros(gen,D_multitask,no_of_tasks); %ÿһ��ÿ������������Ӧ�ȸ���
    task_selection=zeros(1,no_of_tasks);%������ѡ�����
    task_selection_record=zeros(gen,1);%��¼��ѡ������������
    aidtask_selection=zeros(no_of_tasks,no_of_tasks);%�����������
    task_rewards=zeros(gen,no_of_tasks);%������
    aidtask_rewards=zeros(no_of_tasks,no_of_tasks);%����������
    Rb=zeros(gen,no_of_tasks);%������_��ȫ�����ŵ�Ӱ��
    Rp=zeros(gen,no_of_tasks);%���������������ٳ̶�
    zx=zeros(no_of_tasks,D_multitask);%�����Լ�������
    pop_distance=zeros(no_of_tasks,gen);%�������������Ž�ľ���
   
    Q_table=zeros(2*no_of_tasks,no_of_tasks);%Q������ǿ��ѧϰ��ֵ
    task_state=zeros(no_of_tasks,1);%��¼����Ľ���״̬
    U_table=zeros(2*no_of_tasks,no_of_tasks);%����Q����и��������ѡ��
    aidpick_number=zeros(2*no_of_tasks,no_of_tasks);%ÿ��״̬�¸�������ѡ��Ĵ���
    UCB_table=zeros(2*no_of_tasks,no_of_tasks);
    t_num=zeros(1,no_of_tasks);
    globalbest_record=zeros(gen,1);%ͳ��ÿ�������Ÿ���
    dy=zeros(no_of_tasks,1);%ֱ���仯����
    
    
%     epsilon=0.02;
    
   for i=1:no_of_tasks  
       for j= 1:pop_M
           population(i,j) = Chromosome();
           population(i,j) = initialize(population(i,j),D_multitask);
           [population(i,j).rnvec,population(i,j).factorial_costs] = evaluate(population(i,j),Tasks(i),p_il,options);
           population(i,j).population_source=i;

       end 

   end

    factorial_cost=zeros(1,pop_M);  
    %������Ӧ��ֵ�ɸߵ��ͣ�����ֵ��С����
        for i=1:no_of_tasks  
            for j= 1:pop_M
                factorial_cost(j)=population(i,j).factorial_costs; 
            end
            [~,y]=sort(factorial_cost);%����ֵ�ɵ͵�������
            population(i,:)=population(i,y);
            EvBestobj(2,:,i)=population(i,1).rnvec;%ȡ��ÿ�����񵱴������Ÿ��� 
            EvBestFitness(i,2)=population(i,1).factorial_costs;%ȡ��ÿ�����񵱴������Ÿ�����Ӧ��
        end
         
        globalbest=min(EvBestFitness(:,1));
        globalbest_record(1)=globalbest;
      
        for i=1:no_of_tasks
           task_selection(i)=1/no_of_tasks;
        end
        P0=0.3;
        %��ʼ����������ѡ����ʾ���
        for i=1:no_of_tasks
            for j=1:no_of_tasks
                if j==i
                    aidtask_selection(i,j)=1-P0;
                else
                  aidtask_selection(i,j)=P0/(no_of_tasks-1);
                end
            end
        end  
        
        
    %��������:����ԭ�ģ����ж��Ƿ��ȡ��֪ʶ�����ٽ��б��콻��ѡ��
    generation=1;
%     c_num=0;
    
    
    while generation < gen 
        generation = generation + 1;
        disp(generation);
         current_population=population;

            first_gen=B*gen;%����������
            if generation<=first_gen
                task_index=randi([1,no_of_tasks]) ;
            else
                task_index=rouletteWheelSelection(task_selection,1);
            end
                  
%             i=task_index;
            
            if t_num(i)>=5  %ͣ����ֵ
                while task_index==i
                    task_index=randi([1,no_of_tasks]) ;
                end 
            end
            
            
            task_selection_record(generation)=task_index;
            i=task_index;
%             pick_number(i)=pick_number(i)+1;
            
            
            %�����Ӵ���Ⱥ
            for j= 1:pop_M
                offspring(j) = Chromosome();
            end
        
            lb=zeros(1,D_multitask); % ����ȡֵ�½�
            ub=ones(1,D_multitask); % ����ȡֵ�Ͻ�
            
            
            %��ѡ������������Դ
%            disp(task_state(i)); 
            if task_state(i)==0
                q_index=(i-1)*2+2;
            else
                q_index=(i-1)*2+1;
            end
            
            zero_elements = aidpick_number(q_index,:) == 0;
            zero_indices = find(zero_elements);
            
            if numel(zero_indices) >= 1
                % ʹ��randperm����һ��������е�������Ȼ��ȡ��һ��
                disp('���ѡ��������');
                aid_index = zero_indices(randperm(numel(zero_indices), 1));
            else
                temp_q=Q_table(q_index,:);
                Q_min=min(temp_q);
                Q_max=max(temp_q);
                temp_u=U_table(q_index,:);
                U_min=min(temp_u);
                U_max=max(temp_u);
                normalized_Q = (temp_q - Q_min) / (Q_max - Q_min);
                normalized_U = (temp_u - U_min) / (U_max - U_min);
                UCB_table(q_index,:)=normalized_Q+normalized_U;

                  [~, aid_index] = max(UCB_table(q_index,:));
           end

                
            
                aidpick_number(q_index,aid_index)= aidpick_number(q_index,aid_index)+1;
                pick_number=sum(aidpick_number(q_index,:));
                temp_u=2*log(pick_number);
                
                for s=1:no_of_tasks
                    U_table(q_index,s)=(temp_u/aidpick_number(q_index,s))^0.5;
                end
             
                %��Ԫ֪ʶǨ�Ƽӽ���
               
                 %��ÿһ���Ŀ�ʼ����Ԫ֪ʶǨ��
               [tr_population,dy] = AMKT(population,pop_M,generation,EvBestFitness,zx,pop_distance,dy,task_index,aid_index);

               
                %��Ⱥ�ϲ�_����ϲ�
                Pf_population=[current_population(i,:),tr_population];
%                 save Pf_population Pf_population;
               
             
             %�ڲ�����
            for j = 1:pop_M
                % ��ȡ����
                  x=population(i,j).rnvec;

                  %����
                  r1 = unidrnd(pop_M);
                  x1=population(i,r1).rnvec;
                  r2 = unidrnd(2*pop_M);
                  r3 = unidrnd(2*pop_M);
                 while r3 == r2
                     r3 = unidrnd(2*pop_M);
                 end
                  y=x1+F*(Pf_population(r2).rnvec-Pf_population(r3).rnvec); % �����м���
                                    
                     
                    %y
                    % ��ֹ�м���Խ��
                    y=max(y,lb);
                    y=min(y,ub);

               %disp(y);
                %����
                mid_population=Chromosome();
                z=zeros(1,D_multitask);
                j0=randi([1,D_multitask]); 
                for d=1:D_multitask 
                    if d==j0 || rand<=p_cr 
                        z(d)=y(d); 
                    else
                        z(d)=x(d);
                    end
                end
                mid_population.rnvec=z;
                mid_population.population_source=aid_index;
                [~,mid_population.factorial_costs] = evaluate(mid_population,Tasks(i),p_il,options);
                if  mid_population.factorial_costs<=population(i,j).factorial_costs
                    offspring(j)=mid_population;
                else
                    offspring(j)=population(i,j);
                end
            end             


         %���򣬻�õ������Ÿ���
           for w4= 1:pop_M
                factorial_cost(w4)=offspring(w4).factorial_costs; 
           end
            
            [~,s]=sort(factorial_cost);%����ֵ�ɵ͵�������
         
            offspring=offspring(s);
            population(i,:)=offspring(1:pop_M); 
           
            
            EvBestobj(generation,:,i)=population(i,1).rnvec;   %���Ÿ��� 
            EvBestFitness(i,generation)=population(i,1).factorial_costs;%����

           for p=1:no_of_tasks
               if p~=i
                   EvBestFitness(p,generation)=EvBestFitness(p,generation-1);
                   EvBestobj(generation,:,p)=EvBestobj(generation-1,:,p);
                   pop_distance(p,generation)= pop_distance(p,generation-1);
               end
           end
                   
           population= EST(Tasks,population,p_il,options,task_index,aid_index);
           
           EST_population=zeros(1,pop_M);
           %���򣬻�õ������Ÿ���
           for j= 1:pop_M
               EST_population(j)= population(i,j).factorial_costs;
           end   
           [~,s]=sort(EST_population);%����ֵ�ɵ͵�������
          population(i,:)= population(i,s);


          %��ȡ���Ÿ���
         EvBestobj(generation,:,i)= population(i,1).rnvec;   %���Ÿ��� 
         EvBestFitness(i,generation)=population(i,1).factorial_costs;%������Ӧ��
           
 
        popu_rnvec=zeros(pop_M,D_multitask);
        for j=1:pop_M
            popu_rnvec(j,:)=population(i,j).rnvec;
        end
        zx(i,:)=mean(popu_rnvec);

        pre_zx=zx(i,:);
        pre_bestobj=EvBestobj(generation,:,i);
        pop_distance(i,generation)=sqrt(sum((pre_zx-pre_bestobj).^2));


       %���㽱��
       current_best=globalbest;
       globalbest=min(EvBestFitness(:,generation));%����ȫ������
       globalbest_record(generation)=globalbest;

       %������
       fg=(current_best-EvBestFitness(i,generation))/current_best;
       Rb(generation,i)=max(fg,0);
       sum_Rp=0;
       for t=1:pop_M
           fp=(current_population(i,t).factorial_costs-population(i,t).factorial_costs)/current_population(i,t).factorial_costs;
           tem_Rp=max(fp,0);
           sum_Rp=sum_Rp+tem_Rp;
       end
       Rp(generation,i)=sum_Rp/pop_M;
       task_rewards(generation,i)=0.5*Rb(generation,i)+0.5*Rp(generation,i);
        %��������

        if aid_index==i
             aidtask_rewards(i,aid_index)=task_rewards(generation,i);
        else
            if population(i,1).population_source == aid_index
                fg=(current_best-EvBestFitness(i,generation))/current_best;
            else
                fg=0;
            end
            Rb(generation,aid_index)=max(fg,0);

            sum_Rp=0;aidtask_num=0;
            for t=1:pop_M
                if population(i,t).population_source==aid_index
                    aidtask_num=aidtask_num+1;
                    fp=(current_population(i,t).factorial_costs-population(i,t).factorial_costs)/current_population(i,t).factorial_costs;
                    tem_Rp=max(fp,0);
                    sum_Rp=sum_Rp+tem_Rp;
                end
            end
            Rp(generation,aid_index)=sum_Rp/aidtask_num;
            aidtask_rewards(i,aid_index)=0.5*Rb(generation,aid_index)+0.5*Rp(generation,aid_index);
        end
          task_rewards(generation,aid_index)=aidtask_rewards(i,aid_index);


           %���¸�������ѡ�����
          Q_table=QL(Q_table,aidtask_rewards(i,:),i,EvBestFitness,generation,aid_index,q_index,gen,t_num);
           
           %��������ѡ����
           nk=0;p_min=0.1;
           gk=zeros(1,no_of_tasks);
           qk=zeros(1,no_of_tasks);
           for d=1:generation-1
               nk=nk+0.85^(generation-1-d);
           end
           for d=1:generation-1
               for p=1:no_of_tasks
                   gk(p)=gk(p)+0.85^(generation-1-d)*task_rewards(d,p);
               end
           end
           for p1=1:no_of_tasks
               qk(p1)=nk*gk(p1);
           end
           sum_qk=sum(qk);
           
           for p1=1:no_of_tasks
               task_selection(p1)=(p_min/no_of_tasks)+(1-p_min)*(qk(p1)/sum_qk);
           end

           
           %����ٸ����������״̬
           if EvBestFitness(i,generation)==EvBestFitness(i,generation-1) %ͳ���м�������ֲ�����
               t_num(i)=t_num(i)+1;
               task_state(i)=0;
           else
               t_num(i)=0;
               task_state(i)=1;
           end
           
              %ͳһ��Դ
           for j = 1:pop_M
               population(i,j).population_source=i;
           end
      
       disp(['CMTDE Generation = ', num2str(generation), '  The best factorial costs = ', num2str(globalbest)]); 
    end 

%      save EvBestFitness EvBestFitness;
%      save  Q_table  Q_table;

     
    %��ӡ������һ������ֵ
    for i =1:no_of_tasks    
          disp(['CMTDE Generation = ', num2str(generation), '  Task',num2str(i),' best factorial costs = ', num2str(EvBestFitness(i,gen))]);  
    end
    
    %��������ֵ
      data_CMTDE.wall_clock_time=toc;  
      data_CMTDE.EvBestFitness=EvBestFitness(:,gen).';
      data_CMTDE.best=globalbest;

%   
end


%

 