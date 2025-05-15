function selected_indices = rouletteWheelSelection(probability, num_to_select)  
    % 输入：  
    % fitnesses 
    % population_size - 种群大小，即fitnesses数组的长度  
    % num_to_select - 需要选择的个体数量  
      
    % 输出：  
    % selected_indices - 被选中的个体的索引数组  
%     [~,population_size]=size(fitnesses); 
    % 归一化适应度  
    normalized_probability = probability ./ sum(probability);  
      
    % 计算累积概率  
    cumulative_probs = cumsum(normalized_probability);  
      
    % 初始化被选中的个体索引数组  
    selected_indices = zeros(1, num_to_select);  
      
    % 轮盘赌选择  
    for i = 1:num_to_select  
        % 生成一个[0, 1)之间的随机数  
        r = rand();  
%          disp(r); 
        % 查找随机数对应的索引  
        [~, idx] = min(abs(cumulative_probs - r));  
          
        % 保存选中的索引  
        selected_indices(i) = idx;  
          
        cumulative_probs(idx) = Inf;  
    end  
      

    if ~isempty(find(cumulative_probs == Inf))  
        cumulative_probs(~isinf(cumulative_probs)) = cumsum(normalized_probability(~isinf(cumulative_probs)));  
    end  
end
