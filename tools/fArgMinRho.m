function Result = fArgMinRho(ResultsOnGrid,Param)
% This file takes a structure ResultsOnGrid returns a structure that 
% contains the results of the estimation obtained for the value(s) of rho 
% that yeild the minimum value of the objective function.
%--------------------------------------------------------------------------


if strcmp(Param.model,'model_baseline') || strcmp(Param.model,'model_constant') ||...
   strcmp(Param.model,'model_constant_noMA') || strcmp(Param.model,'model_noMA') || ...
   strcmp(Param.model,'model_profile')

    row_index = 0;

    for rhoMale = (0.75:0.01:1)     % loop over all values of rho
        
        row_index = row_index + 1;
        
        % Store the information: rho and value of objective function                    
        temp(row_index,1) = rhoMale;            
        temp(row_index,2) = ResultsOnGrid.(fRhoFlag(rhoMale,[],Param)).f;                    
    
    end;
                
    % given the information stored in temp, we find the rho that is
    % associated with the minimum value of the objective function 

    %Index of minimum value of objective function f
    [~,I]      = min(temp(:,2)); 
    % rho that minimises the objective function f
    ArgMin     = temp(I,1);  
    
    % if rho  close to 1, set it to 1
    %if ArgMin > .975 && ~strwcmp(Param.sample,'bssample_*')
    %    ArgMin = 1;
    %end;
        
    % store the results of the estimation obtained with that particular value
    % of rho in a new structure called Result.
    Result     = ResultsOnGrid.(fRhoFlag(ArgMin,[],Param));               

elseif strcmp(Param.model,'model_dual')
    
    row_index = 0;

    for rhoMale = (0.75:0.01:1)     % loop over all values of rho
        for rhoSpouse = (0.75:0.01:1)
            row_index = row_index + 1;
        
            % Store the information: rho's and value of objective function                    
            temp(row_index,1) = rhoMale; 
            temp(row_index,2) = rhoSpouse;
            temp(row_index,3) = ResultsOnGrid.(fRhoFlag(rhoMale,rhoSpouse,Param)).f; 
        end;
    end;
                
    % given the information stored in temp, we find the combinations of
    % rho's that are associated with the minimum value of the objective function 

    %Index of minimum value of objective function f
    [~,I]      = min(temp(:,3)); 
    % rho's that minimises the objective function f
    ArgMinMale     = temp(I,1);
    ArgMinSpouse   = temp(I,2);

    % if rho  close to 1, set it to 1
    %if ArgMinMale > .975
    %    ArgMinMale = 1;
    %end;
        % if rho  close to 1, set it to 1
    %if ArgMinSpouse > .975
    %    ArgMinSpouse = 1;
    %end;
    
    % store the results of the estimation obtained with that particular value
    % of rho in a new structure called Result.
    Result     = ResultsOnGrid.(fRhoFlag(ArgMinMale,ArgMinSpouse,Param));            
    
end;
end
    
    
    
            
                
