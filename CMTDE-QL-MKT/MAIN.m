
tic

clc
%% MKTDE�Ĳ���
pop_M=100; % ��Ⱥ��С
gen=100; % 
p_il = 0; %�޾ֲ�����
p_cr=0.9;  %�������
F=0.5;   %ͻ���������
B=0.4;  %�����������Ĳ���
total_case=1; %����������������
repetition=1; %�ظ����д���
results_record=zeros(repetition,15);% 4 case �����������
for i=1:repetition
    for j=1:total_case
          ln=5*(j-1)+1;
          Task = UAV_benchmark(j); 
          data_CMTDE=CMTDE(Task,pop_M,gen,p_il,p_cr,F,B); 
          results_record(i,ln:ln+4)=data_CMTDE.EvBestFitness;   
    end
end
save results_record results_record;

toc

%% ��ͼ
