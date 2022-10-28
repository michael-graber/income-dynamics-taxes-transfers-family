function [sigma2Male,omega2Male,VarAlphaMale,VarBetaMale,rhoAlphaBetaMale,thetaMale] = fExtractParam(vX,A)

sigma2Male       = vX(1:A,1);
omega2Male       = vX(A+1:2*A+2,1);
VarAlphaMale     = vX(2*A+3);
VarBetaMale      = vX(2*A+4);
rhoAlphaBetaMale = vX(2*A+5);
thetaMale        = vX(2*A+6);


end