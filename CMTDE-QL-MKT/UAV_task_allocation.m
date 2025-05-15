function total_revenue = UAV_task_allocation( allocation_vector,num_uavs, num_tasks, task_resources, uav_capacities, task_priorities,task_profits)
  
    % Initialize total revenue
    total_revenue = 0;

    allocation_matrix = reshape(allocation_vector, num_uavs, num_tasks);  
    
    remaining_capacities = uav_capacities;
    

    for task_idx = 1:num_tasks
        task_required_resources=task_resources(task_idx);
        
        for uav_idx = 1:num_uavs
            % Calculate the allocated amount based on the ratio
            allocated_resources = allocation_matrix(uav_idx, task_idx) * uav_capacities(uav_idx);
            
     
            allocated_resources =  min([allocated_resources, remaining_capacities(uav_idx), task_required_resources]);

            allocation_matrix(uav_idx, task_idx) = allocated_resources;
            
            % Update remaining resources of the UAV
            remaining_capacities(uav_idx) = remaining_capacities(uav_idx) - allocated_resources;
            

            task_required_resources = task_required_resources - allocated_resources;
            

            if task_required_resources <= 0
                break;
            end
        end
    end
    
    for task_idx = 1:num_tasks
        task_priority = task_priorities(task_idx);
        task_resource=task_resources(task_idx);
        task_profit=task_profits(task_idx);
        allocated_resources_for_task = sum(allocation_matrix(:, task_idx));  % Total resources allocated to the task
        task_revenue = task_priority * (allocated_resources_for_task/task_resource)*task_profit;
        total_revenue = total_revenue + task_revenue;
    end
    
    total_revenue=-total_revenue;
    
    % Output the allocation and total revenue
%     disp('Task Allocation Matrix (UAV-task resource distribution):');
%     disp(allocation_matrix);  % Show the resource allocation matrix
%     disp(['Total Revenue: ', num2str(total_revenue)]);
end

