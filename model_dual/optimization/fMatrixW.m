function W = fMatrixW(sigma2,omega2,rho,theta,A)
%Author: Michael Graber
% This function constructs the matrix A-by-A matrix W given a 
% A-by-1 vector sigma2Male and a 
% (A+2)-by-1 vector omega2=[omega2_{a_min-1},omega2_{a_min},omega2_{a_min+1},...,omega2_{a_max}]
%  Note that we impose the initial condition that omega2_{a_min-1} = omega2_{a_min} = omega2_{a_min+1}

% Allocate space
W =zeros(A,A);

for j=1:A
    for i=1:A
        if i == j % diagonal
            W(i,j) = sigma2(i) + omega2(i+2) + ((theta-rho)^2) * omega2(i+1) + ((rho * theta)^2) * omega2(i);
        elseif j == (i + 1) % off-diagonal - 1
            W(i,j) = (theta - rho) * (omega2(i+2) - rho * theta * omega2(i+1) );      
        elseif j == (i + 2) % off-diagonal - 2
            W(i,j) = - rho * theta * omega2(i+2);
        end;
        W(j,i) = W(i,j);
    end;
    
end;

end