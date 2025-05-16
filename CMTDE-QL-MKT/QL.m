function [Q_table]=QL(Q_table,aidtask_rewards,task_index,EvBestFitness,generation,aid_index,q_index,gen,t_num)
 

a=1-(0.9*(generation/gen));
x=0.8;

% a=0.01;
% x=0.9;

i=task_index;

%本次state
q_index1=q_index;

%这个是next_state
if EvBestFitness(i,generation)==EvBestFitness(i,generation-1)
    q_index2=(i-1)*2+2;
else
    q_index2=(i-1)*2+1;
end


%更新Q表
[maxq,~]=max(Q_table(q_index2,:));
r=aidtask_rewards(aid_index);
% Q_table(q_index1,aid_index)=Q_table(q_index1,aid_index)+a*[r+x*(maxq-Q_table(q_index1,aid_index))];
Q_table(q_index1,aid_index)=(1-a)*Q_table(q_index1,aid_index)+a*[r+x*(maxq-Q_table(q_index1,aid_index))];

 end
