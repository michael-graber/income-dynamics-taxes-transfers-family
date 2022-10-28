function [Aeq,beq,lb,ub] = fConstraints(vX,A)


% Extract Parameters
 [sigma2Male,omega2Male] = fExtractParam(vX,A);

%% lower bounds                           
lb = [zeros(A,1);               %\sigma2Male
      zeros(A+2,1);             %\omega2Male
      0;                        %\VarAlphaMale
      0;                        %\VarBetaMale
      -1;                       %\rhoAlphaBetaMale
      -1];                      %\thetaMale
   
%% upper bounds 
ub = [+inf*ones(A,1);          
      +inf*ones(A+2,1);          
      inf;                      
      inf;                                    
      1;                        
      1];                     
           

%% Linear Equality constraints
Aeq = zeros(4,length(vX));

% Initial conditions on omega2Male
Aeq(1,length(sigma2Male)+1) = 1;  % age 24
Aeq(1,length(sigma2Male)+2) = -1; % age 25

%omega_{a_min} = omega_{a_min+1} 
Aeq(2,length(sigma2Male)+2) = 1;  % age 25
Aeq(2,length(sigma2Male)+3) = -1; % age 26

% Initial conditions
Aeq(1,length(sigma2Male)+1) =  1; 
Aeq(1,length(sigma2Male)+2) = -1;

Aeq(2,length(sigma2Male)+2) =  1;
Aeq(2,length(sigma2Male)+3) = -1;

% Terminal condition
Aeq(3,length(sigma2Male))   =  1;                     % var permanent  shock at age 60
Aeq(3,length(sigma2Male)-1) = -1;                     % var permanent  shock at age 59


Aeq(4,length(sigma2Male)+length(omega2Male)  )   =   1;   % var transitory shock at age 60
Aeq(4,length(sigma2Male)+length(omega2Male)-1)   =  -1;   % var transitory shock at age 59


beq = zeros(4,1);

beq = zeros(4,1);
end