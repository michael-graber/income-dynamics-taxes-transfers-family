function [AutoCovMale,AutoCovSpouse,CrossCov,A,age] = fImportData(rhoMale,rhoSpouse,Param)
% This function imports 
% 1.) The autocovariance matrix for males
% 2.) The autocovariance matrix for the spouse
% 3.) The cross-covariance matrix
% Note that the latter two are only used for the estimation fo the dual
% earner model. Note also, that we calculate the averages across cohorts
% at a given age when we estimate the model for the average cohort. 


if length(Param.cohort)> 1   % Compute Average Cov Matrices for all the cohorts specified in vector index_cohort

    % Vectors of Age Range    
    [age_min,age_max] = fCohortAgeRange(Param.cohort);
    
    % Allocate Space
    dim = max(age_max)-min(age_min); % Dimension of autocovariances of 1st Quasi-Differences, age_max and age_min correspond to income observations.
    
    % The following three 3-dimensional arrays contain the autocovariance
    % matrix of the male spouse, the female spouse and the cross
    % covariances. The latter two are only used when we estimate the dual
    % earner model, else they remain NaN.
    AutoCovArrayMale    = NaN*ones(dim,dim,length(Param.cohort));
    AutoCovArraySpouse  = NaN*ones(dim,dim,length(Param.cohort));
    CrossCovArray       = NaN*ones(dim,dim,length(Param.cohort));

    for i = 1:length(Param.cohort) % loop over cohorts                    
    
        cohort = Param.cohort(i);
    
        if strcmp(Param.model,'model_baseline')      || strcmp(Param.model,'model_constant') ||...
           strcmp(Param.model,'model_constant_noMA') || strcmp(Param.model,'model_noMA') || ...
           strcmp(Param.model,'model_profile')
    
            % Specify filenames for the two autocovariance matrices and 
            % and the cross-covariance matrix
    
            [fileMale,~,~] = filename(Param,Param.cohort(i),rhoMale,[]);
             
            TempMale   = importdata(fileMale);
        
            % Placing the elements in the arrays
            AutoCovArrayMale(age_min(i)- min(age_min) + 1: age_max(i)- min(age_min),...
                             age_min(i)- min(age_min) + 1: age_max(i)- min(age_min),i) = TempMale.data;
                  
        elseif strcmp(Param.model,'model_dual')
        
            % Specify filenames for the two autocovariance matrices and 
            % and the cross-covariance matrix
    
            [fileMale,fileSpouse,fileCross] = filename(Param,Param.cohort(i),rhoMale,rhoSpouse);
             
            TempMale   = importdata(fileMale);
            TempSpouse = importdata(fileSpouse);
            TempCross  = importdata(fileCross);
        
            % Placing the elements in the arrays
            AutoCovArrayMale(age_min(i)- min(age_min) + 1: age_max(i)- min(age_min),...
                             age_min(i)- min(age_min) + 1: age_max(i)- min(age_min),i) = TempMale.data;
        
            AutoCovArraySpouse(age_min(i)- min(age_min) + 1: age_max(i)- min(age_min),...
                               age_min(i)- min(age_min) + 1: age_max(i)- min(age_min),i) = TempSpouse.data;
                     
            CrossCovArray(age_min(i)- min(age_min) + 1: age_max(i)- min(age_min),...
                          age_min(i)- min(age_min) + 1: age_max(i)- min(age_min),i) = TempCross.data;   
        
        end; 
         
    end; % end loop cohorts     

    % Compute mean across 3rd dimension
    AutoCovMale   = nanmean(AutoCovArrayMale,3);
    AutoCovSpouse = nanmean(AutoCovArraySpouse,3);
    CrossCov      = nanmean(CrossCovArray,3);    
    
    % dimension
    A = size(AutoCovMale,2); 

    % Age Range of 1st Quasi-Differences
    age = (min(age_min) + 1 : max(age_max))';


elseif length(Param.cohort) ==  1 % Load Cohort Specific Matrices

        
    % Vectors of Age Range    
    [age_min,age_max] = fCohortAgeRange(Param.cohort);

        
   if strcmp(Param.model,'model_baseline')      || strcmp(Param.model,'model_constant') ||...
      strcmp(Param.model,'model_constant_noMA') || strcmp(Param.model,'model_noMA') || ...
      strcmp(Param.model,'model_profile')
    
      % Specify filenames for the two autocovariance matrices and 
      % and the cross-covariance matrix
    
      [fileMale,~,~] = filename(Param,Param.cohort,rhoMale,[]);      
       
       TempMale   = importdata(fileMale);
        
       AutoCovMale   = TempMale.data;
       AutoCovSpouse = NaN;
       CrossCov      = NaN;
       
   elseif strcmp(Param.model,'model_dual')
         
       % Specify filenames for the two autocovariance matrices and 
       % and the cross-covariance matrix
    
       [fileMale,fileSpouse,fileCross] = filename(Param,Param.cohort,rhoMale,rhoSpouse);
             
        TempMale   = importdata(fileMale);
        TempSpouse = importdata(fileSpouse);
        TempCross  = importdata(fileCross);
        
       % Placing the elements in the arrays
        AutoCovMale   = TempMale.data;
        AutoCovSpouse = TempSpouse.data;
        CrossCov      = TempCross.data;   
             
   end; 
    % dimension
    A = size(AutoCovMale,2);

    % Age Range of 1st Quasi-Differences
    age =  (age_min + 1:age_max)';

    
end;
    

end

