function [Tasks] = UAV_benchmark(index)
%BENCHMARK function
%   Input
%   - index: the index number of problem set
%   Output:
%   - Tasks: benchmark problem set
%   - g1: global optima of Task 1
%   - g2: global optima of Task 2
    switch(index)
        
          case 1
            load('UAV-Task\1_1.mat') 
            dim = 100;
            Tasks(1).dims = dim;
            Tasks(1).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)+5000;
            Tasks(1).Lb=0*ones(1,dim);
            Tasks(1).Ub=1*ones(1,dim);
            
            load('UAV-Task\1_2.mat') 
            dim = 100;
            Tasks(2).dims = dim;
            Tasks(2).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)-200;
            Tasks(2).Lb=0*ones(1,dim);
            Tasks(2).Ub=1*ones(1,dim);
           
            
             load('UAV-Task\1_3.mat') 
            dim = 100;
            Tasks(3).dims = dim;
            Tasks(3).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)+200;
            Tasks(3).Lb=0*ones(1,dim);
            Tasks(3).Ub=1*ones(1,dim);
            
            load('UAV-Task\1_4.mat') 
            dim = 120;
            Tasks(4).dims = dim;
            Tasks(4).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)-1000;
            Tasks(4).Lb=0*ones(1,dim);
            Tasks(4).Ub=1*ones(1,dim);
            
            load('UAV-Task\1_5.mat') 
            dim = 80;
            Tasks(5).dims = dim;
            Tasks(5).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)+100;
            Tasks(5).Lb=0*ones(1,dim);
            Tasks(5).Ub=1*ones(1,dim);
            
      case 2
            load('UAV-Task\1_1.mat') 
            dim = 100;
            Tasks(1).dims = dim;
            Tasks(1).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)+4000;
            Tasks(1).Lb=0*ones(1,dim);
            Tasks(1).Ub=1*ones(1,dim);
            
            load('UAV-Task\1_2.mat') 
            dim = 100;
            Tasks(2).dims = dim;
            Tasks(2).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)+300;
            Tasks(2).Lb=0*ones(1,dim);
            Tasks(2).Ub=1*ones(1,dim);
           
            
             load('UAV-Task\1_3.mat') 
            dim = 100;
            Tasks(3).dims = dim;
            Tasks(3).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)+300;
            Tasks(3).Lb=0*ones(1,dim);
            Tasks(3).Ub=1*ones(1,dim);
            
            load('UAV-Task\1_4.mat') 
            dim = 120;
            Tasks(4).dims = dim;
            Tasks(4).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)+500;
            Tasks(4).Lb=0*ones(1,dim);
            Tasks(4).Ub=1*ones(1,dim);
            
            load('UAV-Task\1_5.mat') 
            dim = 80;
            Tasks(5).dims = dim;
            Tasks(5).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)-1000;
            Tasks(5).Lb=0*ones(1,dim);
            Tasks(5).Ub=1*ones(1,dim);
            
          case 3
            load('UAV-Task\1_1.mat') 
            dim = 100;
            Tasks(1).dims = dim;
            Tasks(1).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)-300;
            Tasks(1).Lb=0*ones(1,dim);
            Tasks(1).Ub=1*ones(1,dim);
            
            load('UAV-Task\1_2.mat') 
            dim = 100;
            Tasks(2).dims = dim;
            Tasks(2).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)+300;
            Tasks(2).Lb=0*ones(1,dim);
            Tasks(2).Ub=1*ones(1,dim);
           
            
             load('UAV-Task\1_3.mat') 
            dim = 100;
            Tasks(3).dims = dim;
            Tasks(3).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)+300;
            Tasks(3).Lb=0*ones(1,dim);
            Tasks(3).Ub=1*ones(1,dim);
            
            load('UAV-Task\1_4.mat') 
            dim = 120;
            Tasks(4).dims = dim;
            Tasks(4).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)+100;
            Tasks(4).Lb=0*ones(1,dim);
            Tasks(4).Ub=1*ones(1,dim);
            
            load('UAV-Task\1_5.mat') 
            dim = 80;
            Tasks(5).dims = dim;
            Tasks(5).fnc = @(x)UAV_task_allocation(x,num_uavs, num_tasks, task_resources, ...
                      uav_capacities, task_priorities,task_profits)-300;
            Tasks(5).Lb=0*ones(1,dim);
            Tasks(5).Ub=1*ones(1,dim);
      end
end