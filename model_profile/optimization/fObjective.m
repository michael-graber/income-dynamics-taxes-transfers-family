function [f,grad]=fObjective(vX,Data,rhoMale,W)

% Extract Parameters:
[sigma2Male,omega2Male,VarAlphaMale,VarBetaMale,rhoAlphaBetaMale,thetaMale] = fExtractParam(vX,Data.A);

% Residuals
R = fResiduals(vX,rhoMale,Data);

% Value of the objective function
f = 0.5 * R'*W * R;

% Analytical Gradient
if nargout > 1
    grad = (fJacobian(vX,rhoMale,Data))'* W * R;
end;

end
