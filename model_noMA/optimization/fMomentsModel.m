function MomentsModel = fMomentsModel(vX,rhoMale,A)
% This function calculates the theoretical moments given parameters.

%% Theoretical AutoCovariance Matrix Omega

% Extract Parameters
[sigma2Male,omega2Male,VarAlphaMale,thetaMale] = fExtractParam(vX,A);

% Allocate space
Omega = zeros(A,A);

for j=1:A
    for i=1:A
        if i == j % diagonal
            Omega(i,j) = sigma2Male(i) + omega2Male(i+2) + ((thetaMale-rhoMale)^2) * omega2Male(i+1) + ((rhoMale * thetaMale)^2) * omega2Male(i);
        elseif j == (i + 1) % off-diagonal - 1
            Omega(i,j) = (thetaMale - rhoMale) * (omega2Male(i+2) - rhoMale * thetaMale * omega2Male(i+1));      
        elseif j == (i + 2) % off-diagonal - 2
            Omega(i,j) = - rhoMale * thetaMale * omega2Male(i+2);
        end;
        Omega(j,i) = Omega(i,j);
    end;    
end;

Omega = (1-rhoMale)^2 * VarAlphaMale * ones(A,A) + Omega; 

%% Create vectors of stacked unique theoretical moments 
MomentsModel = [];

for i = 0:(A-1)
     MomentsModel    = [MomentsModel;diag(Omega,i)]; 
end;

end