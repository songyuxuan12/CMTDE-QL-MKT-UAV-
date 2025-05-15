function data_SOEA = SOEA(Tasks,pop,gen,p_il,p_cr,F)
    
    clc    
%     tic       

    D=Tasks.dims;
  
    options = optimoptions(@fminunc,'Display','off','Algorithm','quasi-newton','MaxIter',2);  
    
    %fnceval_calls = 0;  
    EvBestFitness = zeros(gen); 
    EvBestobj= zeros(gen,D);
    %TotalEvaluations=zeros(gen);  

   % 初始化种群
 
       for i= 1:pop
           population(i) = Chromosome();
           population(i) = initialize(population(i),D);
%            population(i) = evaluate(population(i),Tasks,p_il,options);
            [population(i).rnvec,population(i).factorial_costs] = evaluate_SOO(population(i),Tasks,p_il,options);
           %TotalEvaluations(i,1)=TotalEvaluations(1)+population(i).factorial_costs;%记录初始每个任务的初始适应度值之和
       end     

    factorial_cost=zeros(1,pop);  

            for i= 1:pop
                factorial_cost(i)=population(i).factorial_costs; 
            end
            [xxx,y]=sort(factorial_cost);
            population(:)=population(y);
            EvBestobj(1,:)=population(1).rnvec;
            EvBestFitness(1)=population(1).factorial_costs;

%         save population population;

    
    generation=1;
    while generation < gen
        %disp('进入迭代');
        generation = generation + 1;
        disp(generation);

            lb=zeros(1,D);
            ub=ones(1,D);
%             lb=Tasks.Lb; 
%             ub=Tasks.Ub;

            
            for j = 1:pop          
                % 提取个体
                x=population(j).rnvec;
                %x
                % 变异操作 Mutation

                    r1 = unidrnd(pop);
                    r2 = unidrnd(pop);
                    while r1 == r2
                        r2 = unidrnd(pop);
                    end
                    r3 = unidrnd(pop);
                    while r3 == r2 || r3 == r1
                        r3 = unidrnd(pop);
                    end
                    y=population(r1).rnvec+F*(population(r2).rnvec-population(r3).rnvec); % 产生中间体
                    %y
                    % 防止中间体越界
                    for ik =1:D 
                        if y(ik)<lb(ik)
                            y(ik)=lb(ik);
                        elseif y(ik)>ub(ik)
                            y(ik)=ub(ik); 
                        end
                    end
           
                mid_population=Chromosome();
                z=zeros(1,D);
                j0=randi([1,D]); 
                for d=1:D 
                    if d==j0 || rand<=p_cr 
                        z(d)=y(d); 
                    else
                        z(d)=x(d); 
                    end
                end
                mid_population.rnvec=z;
                %save z z;
                %选择
                     [~,mid_population.factorial_costs] = evaluate_SOO(mid_population,Tasks,p_il,options);
                    if mid_population.factorial_costs <= population(j).factorial_costs
                        %disp([num2str(mid_populition.factorial_costs),num2str(population(i,j).factorial_costs)]);
                        population(j)=mid_population;
                        %disp(['比较后：',num2str(population(i,j).factorial_costs)]);
                    end   
            end

            for i= 1:pop
                factorial_cost(i)=population(i).factorial_costs; 
            end
            [~,y]=sort(factorial_cost);%函数值由低到高排序
            population(:)=population(y);
            EvBestobj(generation,:)=population(1).rnvec;   %最优个体 
            EvBestFitness(generation)=population(1).factorial_costs;%最优适应度
          
%             打印输出每一代
              disp(['DE Generation = ', num2str(generation), '  Task2 best factorial costs = ', num2str(EvBestFitness(generation))]);   
    end
    
%          zhuanzhi=EvBestFitness.';
         save EvBestobj EvBestobj;
         save EvBestFitness EvBestFitness;
%          save zhuanzhi zhuanzhi;
      %函数返回值
      data_SOEA.wall_clock_time=toc;  
      data_SOEA.EvBestFitness=EvBestFitness(gen);
    end
    
    
   
