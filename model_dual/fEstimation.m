function Results = fEstimation(rhoMale,rhoSpouse,Param)
% Author: Michael Graber
% This file sets up the optimization problem (with age-depencdent variances for
% the transitory and permanent shocks) and uses KNITRO to solve the problem


%% Initialise the Problem
%==========================================================================
% Display some information on the screen:
fScreenOutput(Param,rhoMale,rhoSpouse)

% Load Variance Covariance Matrix
[Data.AutoCovMale,Data.AutoCovSpouse,Data.CrossCov,Data.A,Data.age] = fImportData(rhoMale,rhoSpouse,Param);

%% Initial Guess
%==========================================================================
vX0 = [0.2*ones(Data.A,1);    % sigma2Male
       0.04*ones(Data.A+2,1); % omega2Male (including initial conditions prior to start of sample)
       0.01;                  % VarAlphaMale
       0.35;                  % thetaMale
       0.2*ones(Data.A,1);    % sigma2Spouse
       0.04*ones(Data.A+2,1); % omega2Spouse (including initial conditions prior to start of the sample)
       0.01;                  % VarAlphaSpouse
       0.35;                  % thetaSpouse
       0.00*ones(Data.A,1);   % sigmaMaleSpouse
       0.00*ones(Data.A+2,1); % omegaMaleSpouse
       0.00];                 % CovAlphaMaleSpouse
             
%% Equally Weighted Minimum Distance Estimation
%==========================================================================
                          
% Linear Constraints and bounds on the parameters
[Aeq,beq,lb,ub] = fConstraints(vX0,Data.A);

% Call KNITRO
[vX,f,ExitFlag]=ktrlink(@(vX)fObjective(vX,Data,rhoMale,rhoSpouse),vX0,[],[],Aeq,beq,lb,ub,[],[],'./knitro.opt');


%% Saving Parameters
%==========================================================================

[sigma2Male,omega2Male,VarAlphaMale,thetaMale,sigma2Spouse,omega2Spouse,VarAlphaSpouse,thetaSpouse,sigmaMaleSpouse,omegaMaleSpouse,CovAlphaMaleSpouse] = fExtractParam(vX,Data.A);                  
                   
if rhoMale == 1
    VarAlphaMale = NaN;
    CovAlphaMaleSpouse = NaN;
end;
if rhoSpouse == 1
    VarAlphaSpouse = NaN;
    CovAlphaMaleSpouse = NaN;
end;

% Check for Convergence

if ExitFlag == 0 || ExitFlag == -100 % Convergence achieved

    Results = struct(...
    'ExitFlag',ExitFlag,...
    'VarAlphaMale',VarAlphaMale,...
    'VarBetaMale' , NaN,...
    'rhoAlphaBetaMale', NaN,...
    'f',f,...
    'sigma2Male', sigma2Male,...
    'omega2Male',omega2Male,...
    'thetaMale',thetaMale,...
    'age',Data.age,...
    'rhoMale',rhoMale, ...
    'VarAlphaSpouse', VarAlphaSpouse, ...
    'CovAlphaMaleSpouse', CovAlphaMaleSpouse,...
    'CovBetaMaleSpouse', NaN, ...
    'VarBetaSpouse', NaN,...
    'rhoAlphaBetaSpouse', NaN, ...
    'sigma2Spouse', sigma2Spouse,...
    'sigmaMaleSpouse', sigmaMaleSpouse,...
    'omega2Spouse', omega2Spouse,...
    'omegaMaleSpouse',omegaMaleSpouse,...
    'thetaSpouse', thetaSpouse,...
    'rhoSpouse',rhoSpouse);
     
    
else % No Convergence or not optimal solution found
    
     % Make a note in Report
     diary on     
     display('===========================================================')
     display('Warning: No Convergence within Maximum Number of Iterations')
     fScreenOutput(Param,rhoMale,rhoSpouse)
     ExitFlag
     display('===========================================================')
     diary off
    
    % Store result with f = inf so that it is never picked as optimal
       Results = struct(...
    'ExitFlag',ExitFlag,...
    'VarAlphaMale',VarAlphaMale,...
    'VarBetaMale' , NaN,...
    'rhoAlphaBetaMale', NaN,...
    'f',inf,...
    'sigma2Male', sigma2Male,...
    'omega2Male',omega2Male,...
    'thetaMale',thetaMale,...
    'age',Data.age,...
    'rhoMale',rhoMale, ...
    'VarAlphaSpouse', VarAlphaSpouse, ...
    'CovAlphaMaleSpouse', CovAlphaMaleSpouse,...
    'CovBetaMaleSpouse', NaN, ...
    'VarBetaSpouse', NaN,...
    'rhoAlphaBetaSpouse', NaN, ...
    'sigma2Spouse', sigma2Spouse,...
    'sigmaMaleSpouse', sigmaMaleSpouse,...
    'omega2Spouse', omega2Spouse,...
    'omegaMaleSpouse',omegaMaleSpouse,...
    'thetaSpouse', thetaSpouse,...
    'rhoSpouse',rhoSpouse);
       
end;

end