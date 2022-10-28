function [var_y] = fCalculateVar_y(cohort,education,income) 

% Vectors of Age Range    
[age_min,age_max] = fCohortAgeRange(cohort);
    
% Allocate Space
dim = max(age_max)-min(age_min) + 1; 
    
% The following three 3-dimensional array contains the autocovariance
% matrix of the male spouse
AutoCovArray    = NaN*ones(dim,dim,length(cohort));
    
    %% Specify path to correct file that contains the relevant matrix 
    for j = 1:length(cohort)
        % Pooled
        if  strcmp(education,'pooled') && strcmp(income,'market')     
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/_all/Individual_Market.csv']);
        elseif strcmp(education,'pooled') && strcmp(income,'disposable')
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/_all/Individual_Disp.csv']);
        elseif strcmp(education,'pooled') && strcmp(income,'disposable(family)')     
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/_all/Family_Disp.csv']);        
        % Low skill         
        elseif strcmp(education,'lowskill') && strcmp(income,'market')
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/educ1/Individual_Market.csv']);  
        elseif strcmp(education,'lowskill') && strcmp(income,'disposable')
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/educ1/Individual_Disp.csv']);
        elseif strcmp(education,'lowskill') && strcmp(income,'disposable(family)')
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/educ1/Family_Disp.csv']);  
         % Medium Skill     
        elseif strcmp(education,'mediumskill') && strcmp(income,'market')
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/educ2/Individual_Market.csv']);   
        elseif strcmp(education,'mediumskill') && strcmp(income,'disposable')
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/educ2/Individual_Disp.csv']);
        elseif strcmp(education,'mediumskill') && strcmp(income,'disposable(family)')
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/educ2/Family_Disp.csv']);
        % High Skill     
        elseif strcmp(education,'highskill') && strcmp(income,'market')
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/educ3/Individual_Market.csv']);
        elseif strcmp(education,'highskill') && strcmp(income,'disposable')
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/educ3/Individual_Disp.csv']); 
        elseif strcmp(education,'highskill') && strcmp(income,'disposable(family)')
            file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort(j)),'/educ3/Family_Disp.csv']);
        end;
        
        % Import file
        Temp   = importdata(file);
        
        
        % Placing the elements in the arrays
        AutoCovArray(age_min(j)- min(age_min) + 1: age_max(j)- min(age_min) + 1,...
                     age_min(j)- min(age_min) + 1: age_max(j)- min(age_min) + 1,j) = Temp.data;
                 
    end;
    
    % Compute mean across 3rd dimension
    AutoCov   = nanmean(AutoCovArray,3);
    
    % Extract Variance
    var_y = diag(AutoCov);
end