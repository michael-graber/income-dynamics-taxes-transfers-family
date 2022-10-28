function [Aeq,beq,lb,ub] = fConstraints(vX,A)


% Extract Parameters
 [sigma2Male,omega2Male,~] = fExtractParam(vX,A);

%% lower bounds                           
lb = [zeros(A,1);               %\sigma2Male
      zeros(A+2,1);             %\omega2Male 
       0;                       %\VarAlphaMale
       0];                      %\thetaMale (restricted to be 0!)
   
%% upper bounds 
ub = [+inf*ones(A,1);            
      +inf*ones(A+2,1);         
      inf;                         
       0];                    
           

%% Linear Equality constraints
Aeq = zeros(4,length(vX));

% Initial conditions
Aeq(1,length(sigma2Male)+1) =  1; %omega1
Aeq(1,length(sigma2Male)+2) = -1; %omega2

Aeq(2,length(sigma2Male)+2) =  1; %omega2
Aeq(2,length(sigma2Male)+3) = -1; %omega3


% Terminal condition
Aeq(3,length(sigma2Male))   =  1;                     % var permanent  shock at age 60
Aeq(3,length(sigma2Male)-1) = -1;                     % var permanent  shock at age 59


Aeq(4,length(sigma2Male)+length(omega2Male)  )   =   1;   % var transitory shock at age 60
Aeq(4,length(sigma2Male)+length(omega2Male)-1)   =  -1;   % var transitory shock at age 59


beq = zeros(4,1);
end