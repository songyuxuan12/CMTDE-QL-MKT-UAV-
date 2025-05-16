classdef Chromosome    
    properties
        rnvec; % (genotype)--> decode to find design variables --> (phenotype) 
        factorial_costs;
        population_source;
    end    
    methods        
        function object = initialize(object,D) 
            object.rnvec = rand(1,D);       
        end
 
        function [a,b] = evaluate(object,Tasks,p_il,options)     
            [object.rnvec,object.factorial_costs]=fnceval(Tasks,object.rnvec,p_il,options);
            a=object.rnvec;
            b=object.factorial_costs;
        end
        
        function [a,b] = evaluate_SOO(object,Task,p_il,options)   
            [object.rnvec,object.factorial_costs]=fnceval(Task,object.rnvec,p_il,options);
            a=object.rnvec;
            b=object.factorial_costs;
            %calls = funcCount;
        end
        
%          function object=crossover(object,p1,p2,cf)     %交叉
%             object.rnvec=0.5*((1+cf).*p1.rnvec + (1-cf).*p2.rnvec);
%             object.rnvec(object.rnvec>1)=1;
%             object.rnvec(object.rnvec<0)=0;
%         end
%         
%         function object=mutate(object,p,D,sigma)       %突变
%             rvec=normrnd(0,sigma,[1,D]);
%             object.rnvec=p.rnvec+rvec;
%             object.rnvec(object.rnvec>1)=1;
%             object.rnvec(object.rnvec<0)=0;
%         end        

    end
end
