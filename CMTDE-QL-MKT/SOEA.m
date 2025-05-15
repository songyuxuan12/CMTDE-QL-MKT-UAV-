function data_SOEA = SOEA(Tasks,pop,gen,p_il,p_cr,F)
    
    clc    
%     tic       

    D=Tasks.dims;%维度这块：我任务单任务优化应该是自己进化自己的，不应该拉直到统一搜索空间
  
    %定义优化器 p_il 我的理解是控制局部自我学习（局内搜索的概率）
    %p_il=0时候适应度值就是直接将点带入函数求值当作适应度值
    options = optimoptions(@fminunc,'Display','off','Algorithm','quasi-newton','MaxIter',2);  
    
    %fnceval_calls = 0;  % fnceval的调用次数?
    EvBestFitness = zeros(gen); %每一代每个任务的个体最佳适应度
    EvBestobj= zeros(gen,D); %每一代的最佳适应度个体
    %TotalEvaluations=zeros(gen);    %每代的累计适应度值 

    
   % 初始化种群
 
       for i= 1:pop
           population(i) = Chromosome();
           population(i) = initialize(population(i),D);
%            population(i) = evaluate(population(i),Tasks,p_il,options);
            [population(i).rnvec,population(i).factorial_costs] = evaluate_SOO(population(i),Tasks,p_il,options);
           %TotalEvaluations(i,1)=TotalEvaluations(1)+population(i).factorial_costs;%记录初始每个任务的初始适应度值之和
       end     

    factorial_cost=zeros(1,pop);  
    %排序，适应度值由高到低（函数值由小到大）

            for i= 1:pop
                factorial_cost(i)=population(i).factorial_costs; 
            end
            [xxx,y]=sort(factorial_cost);%函数值由低到高排序
            population(:)=population(y);
            EvBestobj(1,:)=population(1).rnvec;%取出每个任务当代的最优个体 
            EvBestFitness(1)=population(1).factorial_costs;%取出每个任务当代的最优个体适应度

%         save population population;
        %初始化两个任务的档案池：定义为空
     
    %代数遍历:按照原文，先判断是否获取“知识”，再进行变异交叉选择
    
    generation=1;
    while generation < gen
        %disp('进入迭代');
        generation = generation + 1;
        disp(generation);
           % 我认为这块仍然应该限制为0-1
            lb=zeros(1,D); % 参数取值下界
            ub=ones(1,D); % 参数取值上界
%             lb=Tasks.Lb; % 参数取值下界  
%             ub=Tasks.Ub; % 参数取值上界

            
            for j = 1:pop          
                % 提取个体
                x=population(j).rnvec;
                %x
                % 变异操作 Mutation

                    %无知识迁移
                 %选择三个不同的个体
                    
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
           
                %变异
                mid_population=Chromosome();%定义一个中间个体，用作比较时的保留
                z=zeros(1,D); % 初始化一个新个体
                j0=randi([1,D]); % 产生一个伪随机数，即选取待交换维度编号
                for d=1:D % 遍历每个维度
                    if d==j0 || rand<=p_cr % 如果当前维度是待交换维度或者随机概率小于交叉概率
                        z(d)=y(d); % 新个体当前维度值等于中间体对应维度值
                    else
                        z(d)=x(d); % 新个体当前维度值等于当前个体对应维度值
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
            %子任务种群遍历结束
            %排序，获得当代最优个体
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
    
    
   