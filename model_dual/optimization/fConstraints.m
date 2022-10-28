function [Aeq,beq,lb,ub] = fConstraints(vX,A)


% Extract Parameters
 [sigma2Male,omega2Male,VarAlphaMale,thetaMale,sigma2Spouse,omega2Spouse,VarAlphaSpouse,thetaSpouse,sigmaMaleSpouse,omegaMaleSpouse,~] = fExtractParam(vX,A);
%% lower bounds                           
lb = [zeros(A,1);               %\sigma2Male
      zeros(A+2,1);             %\omega2Male
      0;                        %\VarAlphaMale
      -1;                       %\thetaMale
      zeros(A,1);               %sigma2Spouse
      zeros(A+2,1);             %omega2Spouse
      0;                        %VarAlphaSpouse
      -1;                       %thetaSpouse
      -inf(A,1);                %sigmaMaleSpouse
      -inf(A+2,1);              %omegaMaleSpouse
      -inf];                    %CovAlphaMaleSpouse
  
%% upper bounds 
ub = [inf(A,1);           %\sigma2Male
      inf(A+2,1);         %\omega2Male
      inf;                %\VarAlphaMale  
      1;                  %\thetaMale
      inf(A,1);           %sigma2Spouse
      inf(A+2,1);         %omega2Spouse
      inf;                %VarAlphaSpouse  
      1-eps;              %thetaSpouse
      inf(A,1);           %sigmaMaleSpouse
      inf(A+2,1);         %omegaMaleSpouse
      inf];               %CovAlphaMaleSpouse            
           

%% Linear Equality constraints
Aeq = zeros(12,length(vX));

% Initial conditions on omega2Male
Aeq(1,length(sigma2Male)+1) = 1;   % age 24
Aeq(1,length(sigma2Male)+2) = -1;  % age 25

Aeq(2,length(sigma2Male)+2) = 1;   % age 25
Aeq(2,length(sigma2Male)+3) = -1;  % age 26

%Terminal condition
Aeq(3,length(sigma2Male))   =  1;   % var permanent shock at  age 60
Aeq(3,length(sigma2Male)-1) = -1;   % var permanent shock at  age 59

Aeq(4,length(sigma2Male)+length(omega2Male))  =  1;  % var transitory shock at age 60
Aeq(4,length(sigma2Male)+length(omega2Male)-1)= -1;  % var transitory shock at age 59


% Initial conditions on omega2Spouse
Aeq(5,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+1) = 1;
Aeq(5,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+2) = -1;

Aeq(6,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+2) = 1;
Aeq(6,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+3) = -1;

% Terminal condition
Aeq(7,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)) = 1;                % var permanent shock at  age 60
Aeq(7,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)-1) = -1;             % var permanent shock at  age 59

Aeq(8,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+length(omega2Spouse)) = 1;      % var  transitory shock at  age 60
Aeq(8,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+length(omega2Spouse)-1) = -1;    % var transitory shock at  age 59

%Initial conditions on omegaMaleSpouse
Aeq(9,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+length(omega2Spouse)+length(VarAlphaSpouse)+length(thetaSpouse)+length(sigmaMaleSpouse)+1) = 1;
Aeq(9,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+length(omega2Spouse)+length(VarAlphaSpouse)+length(thetaSpouse)+length(sigmaMaleSpouse)+2) = -1;

Aeq(10,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+length(omega2Spouse)+length(VarAlphaSpouse)+length(thetaSpouse)+length(sigmaMaleSpouse)+2) = 1;
Aeq(10,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+length(omega2Spouse)+length(VarAlphaSpouse)+length(thetaSpouse)+length(sigmaMaleSpouse)+3) = -1;

%Terminal conditions on omegaMaleSpouse
Aeq(11,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+length(omega2Spouse)+length(VarAlphaSpouse)+length(thetaSpouse)+length(sigmaMaleSpouse)) = 1;     %cov of permanent shocks at age 60
Aeq(11,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+length(omega2Spouse)+length(VarAlphaSpouse)+length(thetaSpouse)+length(sigmaMaleSpouse)-1) = -1;  %cov of permanent shocks at age 59

Aeq(12,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+length(omega2Spouse)+length(VarAlphaSpouse)+length(thetaSpouse)+length(sigmaMaleSpouse)+length(omegaMaleSpouse)) = 1;   %cov of transitory shocks at age 60   
Aeq(12,length(sigma2Male)+length(omega2Male)+length(VarAlphaMale)+length(thetaMale)+length(sigma2Spouse)+length(omega2Spouse)+length(VarAlphaSpouse)+length(thetaSpouse)+length(sigmaMaleSpouse)+length(omegaMaleSpouse)-1) = -1;%cov of transitory shocks at age 59

beq = zeros(12,1);
end