
tic

clc

pop_M=100; % 种群大小
gen=100; % 
p_il = 0; %无局部搜索
p_cr=0.9;  %交叉概率
F=0.5;   %突变比例因数
B=0.4;  %避免冷启动的参数
total_case=1; %多任务问题总数量
repetition=1; %重复运行次数
results_record=zeros(repetition,15);% 4 case 乘以组件数量
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

