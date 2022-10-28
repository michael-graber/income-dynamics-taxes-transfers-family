function [H] = fHessian(vX,lambda,rhoMale,A)

% Hessian

H = fJacobian(vX,rhoMale,A)'*fJacobian(vX,rhoMale,A);

end