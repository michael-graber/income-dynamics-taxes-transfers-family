function [f,grad]=fObjective(vX,Data,rhoMale,W)

% Residuals
R = fResiduals(vX,rhoMale,Data);

% Value of the objective function
f = 0.5 * R'*W * R;

% Analytical Gradient
if nargout > 1
    grad = (fJacobian(vX,rhoMale,Data.A))'* W * R;
end;

end
