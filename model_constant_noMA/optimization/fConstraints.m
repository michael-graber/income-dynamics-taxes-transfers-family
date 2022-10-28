function [Aeq,beq,lb,ub] = fConstraints(vX,A)


% Extract Parameters
 [sigma2Male,omega2Male,~] = fExtractParam(vX,A);

%% lower bounds                           
lb = [zeros(A,1);               %\sigma2Male
      zeros(A+2,1);             %\omega2Male
      0;                        %\VarAlphaMale
      0];                       %\thetaMale, restricted to be 0 !
   
%% upper bounds 
ub = [+inf*ones(A,1);            
      +inf*ones(A+2,1);         
       inf;                          
       0];                    
           

%% Linear Equality constraints
Aeq = zeros(length(sigma2Male)+length(omega2Male),length(vX));

% Constant Variances of Permanent Shocks:
for i = 1:length(sigma2Male)-1
    Aeq(i,i)   =  1; %omega1
    Aeq(i,i+1) = -1; %omega2
end;

% Constant Variances of Transitory Shocks:
for i = 1:length(omega2Male)-1
    Aeq(length(sigma2Male)+i,length(sigma2Male)+i)   =  1; %omega1
    Aeq(length(sigma2Male)+i,length(sigma2Male)+i+1) = -1; %omega2
end;

beq = zeros(length(sigma2Male)+length(omega2Male),1);
end