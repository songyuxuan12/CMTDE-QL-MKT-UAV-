function selected_indices = rouletteWheelSelection(probability, num_to_select)  


    normalized_probability = probability ./ sum(probability);  
      

    cumulative_probs = cumsum(normalized_probability);  
      

    selected_indices = zeros(1, num_to_select);  
      

    for i = 1:num_to_select  

        r = rand();  
%          disp(r); 

        [~, idx] = min(abs(cumulative_probs - r));  
          
        % 保存选中的索引  
        selected_indices(i) = idx;  
          
        cumulative_probs(idx) = Inf;  
    end  
      

    if ~isempty(find(cumulative_probs == Inf))  
        cumulative_probs(~isinf(cumulative_probs)) = cumsum(normalized_probability(~isinf(cumulative_probs)));  
    end  
end
