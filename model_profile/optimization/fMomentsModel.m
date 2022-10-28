function MomentsModel = fMomentsModel(vX,rhoMale,Data)
% This function calculates the theoretical moments given parameters.

%% Theoretical AutoCovariance Matrix Omega

% Extract Parameters:
[sigma2Male,omega2Male,VarAlphaMale,VarBetaMale,rhoAlphaBetaMale,thetaMale] = fExtractParam(vX,Data.A);


% Allocate space
Omega = zeros(Data.A,Data.A);

for j=1:Data.A
    for i=1:Data.A
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

AutoCov =  [(1-rhoMale)*ones(Data.A,1), (1-rhoMale) * (Data.age - min(Data.age) + 1) + rhoMale] ...
        * [VarAlphaMale, rhoAlphaBetaMale * sqrt(VarAlphaMale) * sqrt(VarBetaMale);
          rhoAlphaBetaMale * sqrt(VarAlphaMale) * sqrt(VarBetaMale), VarBetaMale]...
        * [(1-rhoMale)*ones(Data.A,1), (1-rhoMale)  * (Data.age - min(Data.age) + 1) + rhoMale]' ...
        + Omega; 

%% Create vectors of stacked unique theoretical moments 
MomentsModel = [];

for i = 0:(Data.A-1)
     MomentsModel    = [MomentsModel;diag(AutoCov,i)]; 
end;

end