function [tr_population,dy] = AMKT(population,pop_M,generation,~,zx,pop_distance,dy,task_index,aid_index)


%ÿ��Ǩ�ƶ��½�һ���н���Ⱥ
for j=1:pop_M
    tr_population(j)=Chromosome();
end


    if generation>2 && pop_distance(task_index,generation-1)>pop_distance(task_index,generation-2) %���ž�����
        %����ֲ����ţ����������뾶��������������Ž�������֮��ľ���
        distance=pop_distance(task_index,generation-1);
        max_radius=ceil(distance);
        radius=distance+(max_radius-distance)*rand(1,1); %Ǩ�ƹ����ķ�Χ���󡪡��������Χ
        dy(task_index)=dy(task_index)+1;

    %    ��֤�����Ž��½���������Сʱ����Ⱥ��������СǨ�ư뾶
    elseif generation>2 && pop_distance(task_index,generation-1)<pop_distance(task_index,generation-2) %���ž�����С
        distance=pop_distance(task_index,generation-1);
        min_radius=floor(distance);
        radius=min_radius+(distance-min_radius)*rand(1,1);
        dy(task_index)=dy(task_index)+1;
    else
        radius=1;
    end

   %���Ǩ��

    
    for u=1:pop_M
    %         disp(u);
        tr_population(u).rnvec=radius*(population(aid_index,u).rnvec-zx(aid_index,:))+zx(task_index,:);
        tr_population(u).population_source=aid_index;
    end
    

end


