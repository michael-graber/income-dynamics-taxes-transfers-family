function C = fMatrixC(sigmaMaleSpouse,omegaMaleSpouse,rhoMale,rhoSpouse,thetaMale,thetaSpouse,A)


% Allocate space
C =zeros(A,A);

for j=1:A
    for i=1:A
        if i == j % diagonal
            C(i,j) = sigmaMaleSpouse(i) + omegaMaleSpouse(i+2) + (thetaMale-rhoMale)*(thetaSpouse-rhoSpouse) * omegaMaleSpouse(i+1) + (rhoMale * thetaMale)*(rhoSpouse * thetaSpouse) * omegaMaleSpouse(i);
        elseif j == (i + 1) % 1-above-diagonal
            C(i,j) = (thetaSpouse - rhoSpouse) * (omegaMaleSpouse(i+2) - rhoSpouse * thetaSpouse * omegaMaleSpouse(i+1) );      
        elseif j == (i + 2) % 2-above-diagonal
            C(i,j) = - rhoSpouse * thetaSpouse * omegaMaleSpouse(i+2);
        elseif i == (j + 1) % 1-below diagonal
            C(i,j) = (thetaMale - rhoMale) * (omegaMaleSpouse(i+2) - rhoMale * thetaMale * omegaMaleSpouse(i+1));
        elseif i == (j + 2) % 2- below diagonal
            C(i,j) = - rhoMale * thetaMale * omegaMaleSpouse(i+2);
        end;
    end;
    
end;

end