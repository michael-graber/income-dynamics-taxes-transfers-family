function [f]=fObjective(vX,Data,rhoMale,rhoSpouse)

% Extract Parameters:
[sigma2Male,omega2Male,VarAlphaMale,thetaMale,sigma2Spouse,omega2Spouse,VarAlphaSpouse,thetaSpouse,sigmaMaleSpouse,omegaMaleSpouse,CovAlphaMaleSpouse] = fExtractParam(vX,Data.A);

% Empirical Moments
M_AutoCovMale    = Data.AutoCovMale(triu(ones(Data.A)) == 1);   % vector of stacked unique empirical moments, columnwise
M_AutoCovSpouse  = Data.AutoCovSpouse(triu(ones(Data.A)) == 1); % vector of stacked unique empirical moments, columnwise
M_CrossCov       = Data.CrossCov(ones(Data.A) == 1); % vector of stacked unique empirical moments, columnwise

M = [M_AutoCovMale;M_AutoCovSpouse;M_CrossCov];

% Theoretical Moments
AutoCovMale         = ( ((1-rhoMale)^2) * VarAlphaMale *ones(Data.A,Data.A)) + fMatrixW(sigma2Male,omega2Male,rhoMale,thetaMale,Data.A); 
Mhat_AutoCovMale    = AutoCovMale(triu(ones(Data.A)) == 1);      % vector of stacked unique theoretical moments

AutoCovSpouse       = ( ((1-rhoSpouse)^2) * VarAlphaSpouse *ones(Data.A,Data.A)) + fMatrixW(sigma2Spouse,omega2Spouse,rhoSpouse,thetaSpouse,Data.A); 
Mhat_AutoCovSpouse  = AutoCovSpouse(triu(ones(Data.A)) == 1);      % vector of stacked unique theoretical moments

CrossCov            = ( (1-rhoMale) *(1-rhoSpouse) * CovAlphaMaleSpouse *ones(Data.A,Data.A)) + fMatrixC(sigmaMaleSpouse,omegaMaleSpouse,rhoMale,rhoSpouse,thetaMale,thetaSpouse,Data.A); 
Mhat_CrossCov       = CrossCov(ones(Data.A) == 1);      % vector of stacked unique theoretical moments

Mhat = [Mhat_AutoCovMale;Mhat_AutoCovSpouse;Mhat_CrossCov];

% Value of the objective function: Equally Weighted Minimum Distance
f = (M-Mhat)'*(M-Mhat);

end
