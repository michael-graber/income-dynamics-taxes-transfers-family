function R = fResiduals(vX,rhoMale,Data)
% This function calculates the vector of residuals between the theoretical and the
% corresponding empirical moment

R = fMomentsModel(vX,rhoMale,Data.A) - fMomentsData(Data);

end