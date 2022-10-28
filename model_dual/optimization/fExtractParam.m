function [sigma2Male,omega2Male,VarAlphaMale,thetaMale,sigma2Spouse,omega2Spouse,VarAlphaSpouse,thetaSpouse,sigmaMaleSpouse,omegaMaleSpouse,CovAlphaMaleSpouse] = fExtractParam(vX,A)

%length of vectors:
lsigma = A;
lomega = A+2;


sigma2Male       = vX(1:lsigma,1);
omega2Male       = vX(lsigma+1:lsigma+lomega,1);
VarAlphaMale     = vX(lsigma+lomega+1,1);
thetaMale        = vX(lsigma+lomega+2,1);
sigma2Spouse     = vX(lsigma+lomega+3:2*lsigma+lomega+2,1);
omega2Spouse     = vX(2*lsigma+lomega+3:2*lsigma+2*lomega+2,1);
VarAlphaSpouse   = vX(2*lsigma+2*lomega+3,1);
thetaSpouse      = vX(2*lsigma+2*lomega+4,1);
sigmaMaleSpouse  = vX(2*lsigma+2*lomega+5:3*lsigma+2*lomega+4,1);
omegaMaleSpouse  = vX(3*lsigma+2*lomega+5:3*lsigma+3*lomega+4,1);
CovAlphaMaleSpouse=vX(3*lsigma+3*lomega+5);


end