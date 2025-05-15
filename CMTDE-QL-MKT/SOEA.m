function data_SOEA = SOEA(Tasks,pop,gen,p_il,p_cr,F)
    
    clc    
%     tic       

    D=Tasks.dims;%ά����飺�����������Ż�Ӧ�����Լ������Լ��ģ���Ӧ����ֱ��ͳһ�����ռ�
  
    %�����Ż��� p_il �ҵ�����ǿ��ƾֲ�����ѧϰ�����������ĸ��ʣ�
    %p_il=0ʱ����Ӧ��ֵ����ֱ�ӽ�����뺯����ֵ������Ӧ��ֵ
    options = optimoptions(@fminunc,'Display','off','Algorithm','quasi-newton','MaxIter',2);  
    
    %fnceval_calls = 0;  % fnceval�ĵ��ô���?
    EvBestFitness = zeros(gen); %ÿһ��ÿ������ĸ��������Ӧ��
    EvBestobj= zeros(gen,D); %ÿһ���������Ӧ�ȸ���
    %TotalEvaluations=zeros(gen);    %ÿ�����ۼ���Ӧ��ֵ 

    
   % ��ʼ����Ⱥ
 
       for i= 1:pop
           population(i) = Chromosome();
           population(i) = initialize(population(i),D);
%            population(i) = evaluate(population(i),Tasks,p_il,options);
            [population(i).rnvec,population(i).factorial_costs] = evaluate_SOO(population(i),Tasks,p_il,options);
           %TotalEvaluations(i,1)=TotalEvaluations(1)+population(i).factorial_costs;%��¼��ʼÿ������ĳ�ʼ��Ӧ��ֵ֮��
       end     

    factorial_cost=zeros(1,pop);  
    %������Ӧ��ֵ�ɸߵ��ͣ�����ֵ��С����

            for i= 1:pop
                factorial_cost(i)=population(i).factorial_costs; 
            end
            [xxx,y]=sort(factorial_cost);%����ֵ�ɵ͵�������
            population(:)=population(y);
            EvBestobj(1,:)=population(1).rnvec;%ȡ��ÿ�����񵱴������Ÿ��� 
            EvBestFitness(1)=population(1).factorial_costs;%ȡ��ÿ�����񵱴������Ÿ�����Ӧ��

%         save population population;
        %��ʼ����������ĵ����أ�����Ϊ��
     
    %��������:����ԭ�ģ����ж��Ƿ��ȡ��֪ʶ�����ٽ��б��콻��ѡ��
    
    generation=1;
    while generation < gen
        %disp('�������');
        generation = generation + 1;
        disp(generation);
           % ����Ϊ�����ȻӦ������Ϊ0-1
            lb=zeros(1,D); % ����ȡֵ�½�
            ub=ones(1,D); % ����ȡֵ�Ͻ�
%             lb=Tasks.Lb; % ����ȡֵ�½�  
%             ub=Tasks.Ub; % ����ȡֵ�Ͻ�

            
            for j = 1:pop          
                % ��ȡ����
                x=population(j).rnvec;
                %x
                % ������� Mutation

                    %��֪ʶǨ��
                 %ѡ��������ͬ�ĸ���
                    
                    r1 = unidrnd(pop);
                    r2 = unidrnd(pop);
                    while r1 == r2
                        r2 = unidrnd(pop);
                    end
                    r3 = unidrnd(pop);
                    while r3 == r2 || r3 == r1
                        r3 = unidrnd(pop);
                    end
                    y=population(r1).rnvec+F*(population(r2).rnvec-population(r3).rnvec); % �����м���
                    %y
                    % ��ֹ�м���Խ��
                    for ik =1:D 
                        if y(ik)<lb(ik)
                            y(ik)=lb(ik);
                        elseif y(ik)>ub(ik)
                            y(ik)=ub(ik); 
                        end
                    end
           
                %����
                mid_population=Chromosome();%����һ���м���壬�����Ƚ�ʱ�ı���
                z=zeros(1,D); % ��ʼ��һ���¸���
                j0=randi([1,D]); % ����һ��α���������ѡȡ������ά�ȱ��
                for d=1:D % ����ÿ��ά��
                    if d==j0 || rand<=p_cr % �����ǰά���Ǵ�����ά�Ȼ����������С�ڽ������
                        z(d)=y(d); % �¸��嵱ǰά��ֵ�����м����Ӧά��ֵ
                    else
                        z(d)=x(d); % �¸��嵱ǰά��ֵ���ڵ�ǰ�����Ӧά��ֵ
                    end
                end
                mid_population.rnvec=z;
                %save z z;
                %ѡ��
                     [~,mid_population.factorial_costs] = evaluate_SOO(mid_population,Tasks,p_il,options);
                    if mid_population.factorial_costs <= population(j).factorial_costs
                        %disp([num2str(mid_populition.factorial_costs),num2str(population(i,j).factorial_costs)]);
                        population(j)=mid_population;
                        %disp(['�ȽϺ�',num2str(population(i,j).factorial_costs)]);
                    end   
            end
            %��������Ⱥ��������
            %���򣬻�õ������Ÿ���
            for i= 1:pop
                factorial_cost(i)=population(i).factorial_costs; 
            end
            [~,y]=sort(factorial_cost);%����ֵ�ɵ͵�������
            population(:)=population(y);
            EvBestobj(generation,:)=population(1).rnvec;   %���Ÿ��� 
            EvBestFitness(generation)=population(1).factorial_costs;%������Ӧ��
          
%             ��ӡ���ÿһ��
              disp(['DE Generation = ', num2str(generation), '  Task2 best factorial costs = ', num2str(EvBestFitness(generation))]);   
    end
    
%          zhuanzhi=EvBestFitness.';
         save EvBestobj EvBestobj;
         save EvBestFitness EvBestFitness;
%          save zhuanzhi zhuanzhi;
      %��������ֵ
      data_SOEA.wall_clock_time=toc;  
      data_SOEA.EvBestFitness=EvBestFitness(gen);
    end
    
    
   