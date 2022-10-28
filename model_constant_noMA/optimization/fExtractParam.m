function [sigma2Male,omega2Male,VarAlphaMale,thetaMale] = fExtractParam(vX,A)

sigma2Male       = vX(1:A,1);
omega2Male       = vX(A+1:2*A+2,1);
VarAlphaMale     = vX(2*A+3,1);
thetaMale        = vX(2*A+4,1);


end