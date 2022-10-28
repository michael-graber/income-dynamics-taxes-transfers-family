function [H] = fHessian(vX,lambda,rhoMale,Data)

% Hessian

H = fJacobian(vX,rhoMale,Data)'*fJacobian(vX,rhoMale,Data);

end