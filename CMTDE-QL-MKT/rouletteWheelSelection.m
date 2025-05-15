function selected_indices = rouletteWheelSelection(probability, num_to_select)  
    % ���룺  
    % fitnesses - �������Ӧ�����飬ͨ��Ϊһ����������  
    % population_size - ��Ⱥ��С����fitnesses����ĳ���  
    % num_to_select - ��Ҫѡ��ĸ�������  
      
    % �����  
    % selected_indices - ��ѡ�еĸ������������  
%     [~,population_size]=size(fitnesses); 
    % ��һ����Ӧ��  
    normalized_probability = probability ./ sum(probability);  
      
    % �����ۻ�����  
    cumulative_probs = cumsum(normalized_probability);  
      
    % ��ʼ����ѡ�еĸ�����������  
    selected_indices = zeros(1, num_to_select);  
      
    % ���̶�ѡ��  
    for i = 1:num_to_select  
        % ����һ��[0, 1)֮��������  
        r = rand();  
%          disp(r); 
        % �����������Ӧ������  
        [~, idx] = min(abs(cumulative_probs - r));  
          
        % ����ѡ�е�����  
        selected_indices(i) = idx;  
          
        % �����ظ�ѡ�񣨿�ѡ����������ظ�ѡ����ע�͵��������У�  
        cumulative_probs(idx) = Inf;  
    end  
      
    % ����������ظ�ѡ���������ۻ���������  
    if ~isempty(find(cumulative_probs == Inf))  
        cumulative_probs(~isinf(cumulative_probs)) = cumsum(normalized_probability(~isinf(cumulative_probs)));  
    end  
end