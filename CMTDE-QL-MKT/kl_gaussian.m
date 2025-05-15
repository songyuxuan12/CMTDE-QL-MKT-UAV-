% function kl_divergence = kl_gaussian(mu1, Sigma1, mu2, Sigma2)  
%     % 输入:  
%     % mu1, mu2 - 均值向量  
%     % Sigma1, Sigma2 - 协方差矩阵  
%       
%     % 输出:  
%     % kl_divergence - KL散度  
%       
%     % 维度数  
%     k = length(mu1);  
%       
%     % 计算第一部分：trace(Sigma2^-1 * Sigma1) 
%     if det(Sigma2)==0
%         d=pinv(Sigma2);
%     else
%         d=inv(Sigma2);
%     end
%     trace_part = trace(d * Sigma1);  
%       
%     % 计算第二部分：(mu2 - mu1)' * Sigma2^-1 * (mu2 - mu1)  
%     diff_mu = mu2 - mu1;  
%     mu_part = diff_mu' * d * diff_mu;  
%       
%     % 计算第三部分：log(det(Sigma2) / det(Sigma1))  
%     det_part = log(det(Sigma2) / det(Sigma1));  
%       disp(det(Sigma1));
%     % 计算总的KL散度  
%     kl_divergence = 0.5 * (trace_part + mu_part - k + det_part);  
% end


function kl = kl_gaussian(mu1, sigma1, mu2, sigma2, reg_param)  
    % mu1, mu2: 均值向量，列向量  
    % sigma1, sigma2: 协方差矩阵，可能奇异  
    % reg_param: 正则化参数，一个小的正数  
      
    % 正则化协方差矩阵  
    sigma1_reg = sigma1 + reg_param * eye(size(sigma1, 1));  
    sigma2_reg = sigma2 + reg_param * eye(size(sigma2, 1));  
      
    % 计算迹的部分  
    trace_term = sum(sum(sigma2_reg \ sigma1_reg));  
      
    % 计算均值差异的部分  
    diff_mu = mu1 - mu2;  
    diff_mu_squared = diff_mu' * (sigma2_reg \ diff_mu);  
      
    % 计算行列式的部分  
    det_term = log(det(sigma2_reg) / det(sigma1_reg));  
      
    % 计算维度数  
    d = length(mu1);  
      
    % 组合所有部分得到KL散度  
    kl = 0.5 * (trace_term + diff_mu_squared - det_term - d);  
end