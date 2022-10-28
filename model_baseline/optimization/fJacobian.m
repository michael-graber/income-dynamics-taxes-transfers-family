function [J] = fJacobian(vX,rhoMale,A)

% Extract Parameters
 [~,omega2Male,~,thetaMale] = fExtractParam(vX,A);


% Calculate auxiliary matrices
J11    = eye(A,A);
J12aux = diag(ones(A+2,1)) + diag(((thetaMale - rhoMale)^2)*ones(A+1,1),-1) + diag((thetaMale^2)*(rhoMale^2)*ones(A,1),-2);
J12    = J12aux(3:end,:);
J13    = [ones(A,1) * (1-rhoMale)^2, 2 * (thetaMale - rhoMale) * omega2Male(2:end-1) + 2 * thetaMale * (rhoMale^2) * omega2Male(1:end-2)];
J21    = zeros(A-1,A);
J22aux = diag((thetaMale - rhoMale)*ones(A+2,1)) + diag(-(thetaMale - rhoMale) * rhoMale * thetaMale * ones(A+1,1),-1) + diag(zeros(A,1),-2);
J22    = J22aux(3:end-1,:);
J23    = [ones(A-1,1) * (1-rhoMale)^2, omega2Male(3:end-1) + ((rhoMale^2) - 2 * thetaMale * rhoMale) * omega2Male(2:end-2)];
J31    = zeros(A-2,A);
J32aux = diag(-rhoMale * thetaMale * ones(A+2,1)) + diag(zeros(A+1,1),-1) + diag(zeros(A,1),-2); 
J32    = J32aux(3:end-2,:);
J33    = [ones(A-2,1) * (1-rhoMale)^2, -rhoMale * omega2Male(3:end-2)];
J41    = zeros((A-3)*(A-2)/2,A);
J42    = zeros((A-3)*(A-2)/2,A+2);
J43    = [ones((A-3)*(A-2)/2,1) * (1-rhoMale)^2, zeros((A-3)*(A-2)/2,1)];



% Jacobian
J =  [J11,J12,J13;
      J21,J22,J23;
      J31,J32,J33;
      J41,J42,J43];
       
end