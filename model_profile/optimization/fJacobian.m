function [J] = fJacobian(vX,rhoMale,Data)

% Extract Parameters
[~,omega2Male,VarAlphaMale,VarBetaMale,rhoAlphaBetaMale,thetaMale] = fExtractParam(vX,Data.A);


% Calculate auxiliary matrices
sigma1 = [(1-rhoMale)*ones(Data.A,1), (1-rhoMale) * Data.age + rhoMale] ...
        * [1, 0.5 * rhoAlphaBetaMale * sqrt(VarBetaMale)/sqrt(VarAlphaMale);
          0.5 * rhoAlphaBetaMale * sqrt(VarBetaMale)/sqrt(VarAlphaMale), 0]...
        * [(1-rhoMale)*ones(Data.A,1), (1-rhoMale) * Data.age + rhoMale]';

sigma2 = [(1-rhoMale)*ones(Data.A,1), (1-rhoMale) * Data.age + rhoMale] ...
        * [0, 0.5 * rhoAlphaBetaMale * sqrt(VarAlphaMale)/sqrt(VarBetaMale);
          0.5 * rhoAlphaBetaMale * sqrt(VarAlphaMale)/sqrt(VarBetaMale), 1]...
        * [(1-rhoMale)*ones(Data.A,1), (1-rhoMale) * Data.age + rhoMale]';    
    
sigma3 = [(1-rhoMale)*ones(Data.A,1), (1-rhoMale) * Data.age + rhoMale] ...
        * [0, sqrt(VarAlphaMale) * sqrt(VarBetaMale);
          sqrt(VarAlphaMale) * sqrt(VarBetaMale), 0]...
        * [(1-rhoMale)*ones(Data.A,1), (1-rhoMale) * Data.age + rhoMale]';    
    

    



J11    = eye(Data.A,Data.A);
J12aux = diag(ones(Data.A+2,1)) + diag(((thetaMale - rhoMale)^2)*ones(Data.A+1,1),-1) + diag((thetaMale^2)*(rhoMale^2)*ones(Data.A,1),-2);
J12    = J12aux(3:end,:);
J13    = [diag(sigma1,0),diag(sigma2,0),diag(sigma3,0)];
J14    = 2 * (thetaMale - rhoMale) * omega2Male(2:end-1) + 2 * thetaMale * (rhoMale^2) * omega2Male(1:end-2);

J21    = zeros(Data.A-1,Data.A);
J22aux = diag((thetaMale - rhoMale)*ones(Data.A+2,1)) + diag(-(thetaMale - rhoMale) * rhoMale * thetaMale * ones(Data.A+1,1),-1) + diag(zeros(Data.A,1),-2);
J22    = J22aux(3:end-1,:);
J23    = [diag(sigma1,1),diag(sigma2,1),diag(sigma3,1)];
J24    = omega2Male(3:end-1) + ((rhoMale^2) - 2 * thetaMale * rhoMale) * omega2Male(2:end-2);

J31    = zeros(Data.A-2,Data.A);
J32aux = diag(-rhoMale * thetaMale * ones(Data.A+2,1)) + diag(zeros(Data.A+1,1),-1) + diag(zeros(Data.A,1),-2); 
J32    = J32aux(3:end-2,:);
J33    = [diag(sigma1,2),diag(sigma2,2),diag(sigma3,2)];
J34    = -rhoMale * omega2Male(3:end-2);


J41    = zeros((Data.A-3)*(Data.A-2)/2,Data.A);
J42    = zeros((Data.A-3)*(Data.A-2)/2,Data.A+2);
J43    = []; 
for i = 3:(Data.A-1)
     J43    = [J43;[diag(sigma1,i),diag(sigma2,i),diag(sigma3,i)]]; 
end;
J44    = zeros((Data.A-3)*(Data.A-2)/2,1);



% Jacobian
J =  [J11,J12,J13,J14;
      J21,J22,J23,J24;
      J31,J32,J33,J34;
      J41,J42,J43,J44];
       
end