function [tr_population,dy] = AMKT(population,pop_M,generation,~,zx,pop_distance,dy,task_index,aid_index)


%每轮迁移都新建一个承接种群
for j=1:pop_M
    tr_population(j)=Chromosome();
end


    if generation>2 && pop_distance(task_index,generation-1)>pop_distance(task_index,generation-2) %质优距离变大
        %陷入局部最优，扩大收敛半径，随机数超过最优解与质心之间的距离
        distance=pop_distance(task_index,generation-1);
        max_radius=ceil(distance);
        radius=distance+(max_radius-distance)*rand(1,1); %迁移过来的范围扩大——超过最大范围
        dy(task_index)=dy(task_index)+1;

    %    验证：最优解下降，距离缩小时，种群收敛—缩小迁移半径
    elseif generation>2 && pop_distance(task_index,generation-1)<pop_distance(task_index,generation-2) %质优距离缩小
        distance=pop_distance(task_index,generation-1);
        min_radius=floor(distance);
        radius=min_radius+(distance-min_radius)*rand(1,1);
        dy(task_index)=dy(task_index)+1;
    else
        radius=1;
    end

   %解的迁移

    
    for u=1:pop_M
    %         disp(u);
        tr_population(u).rnvec=radius*(population(aid_index,u).rnvec-zx(aid_index,:))+zx(task_index,:);
        tr_population(u).population_source=aid_index;
    end
    

end


