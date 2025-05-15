% function kl_divergence = kl_gaussian(mu1, Sigma1, mu2, Sigma2)  
%     % ����:  
%     % mu1, mu2 - ��ֵ����  
%     % Sigma1, Sigma2 - Э�������  
%       
%     % ���:  
%     % kl_divergence - KLɢ��  
%       
%     % ά����  
%     k = length(mu1);  
%       
%     % �����һ���֣�trace(Sigma2^-1 * Sigma1) 
%     if det(Sigma2)==0
%         d=pinv(Sigma2);
%     else
%         d=inv(Sigma2);
%     end
%     trace_part = trace(d * Sigma1);  
%       
%     % ����ڶ����֣�(mu2 - mu1)' * Sigma2^-1 * (mu2 - mu1)  
%     diff_mu = mu2 - mu1;  
%     mu_part = diff_mu' * d * diff_mu;  
%       
%     % ����������֣�log(det(Sigma2) / det(Sigma1))  
%     det_part = log(det(Sigma2) / det(Sigma1));  
%       disp(det(Sigma1));
%     % �����ܵ�KLɢ��  
%     kl_divergence = 0.5 * (trace_part + mu_part - k + det_part);  
% end


function kl = kl_gaussian(mu1, sigma1, mu2, sigma2, reg_param)  
    % mu1, mu2: ��ֵ������������  
    % sigma1, sigma2: Э������󣬿�������  
    % reg_param: ���򻯲�����һ��С������  
      
    % ����Э�������  
    sigma1_reg = sigma1 + reg_param * eye(size(sigma1, 1));  
    sigma2_reg = sigma2 + reg_param * eye(size(sigma2, 1));  
      
    % ���㼣�Ĳ���  
    trace_term = sum(sum(sigma2_reg \ sigma1_reg));  
      
    % �����ֵ����Ĳ���  
    diff_mu = mu1 - mu2;  
    diff_mu_squared = diff_mu' * (sigma2_reg \ diff_mu);  
      
    % ��������ʽ�Ĳ���  
    det_term = log(det(sigma2_reg) / det(sigma1_reg));  
      
    % ����ά����  
    d = length(mu1);  
      
    % ������в��ֵõ�KLɢ��  
    kl = 0.5 * (trace_term + diff_mu_squared - det_term - d);  
end