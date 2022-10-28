function [] = main_1storderautocorrelation(cohort,education,income)
% 1st order autocorrelation for INCOME DYNAMICS OVER THE LIFE CYCLE
% Date:    December 2013
% Author:  Michael Graber
%
% This function takes as INPUTS:
%
% cohort : either the year (e.g. 1925) or a row-vector (1925:1964)'. In the
%          latter case the results are average cohort effects.
% education: one of the following strings:
%          'pooled'
%          'lowskill'
%          'mediumskill'
%          'highskill'
% income:  one fo the following strings:
%          'market'
%          'disposable'
%          'disposable(family)'
%
% This function saves the life-cycle profile of the 1st order
% autocorrelation coefficient for the baseline sample in
% "./sample_baseline/moments/autocov/cohort_income_education.csv"
%--------------------------------------------------------------------------

% Load model-specific files and make sample-specific fiolders accessible:
restoredefaultpath;
workingDir = '/data/uctpmgr/BitBucket/BlundellGraberMogstad'; cd(workingDir)
addpath(genpath('tools'));                  % Tools

if length(cohort) == 1  % cohort-specific profiles

%% ------------------- Import Data ----------------------------------------
% Specify path to correct file that contains the relevant matrix 

    % Pooled
    if  strcmp(education,'pooled') && strcmp(income,'market')     
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/_all/Individual_Market.csv']);
    elseif strcmp(education,'pooled') && strcmp(income,'disposable')
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/_all/Individual_Disp.csv']);
    elseif strcmp(education,'pooled') && strcmp(income,'disposable(family)')     
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/_all/Family_Disp.csv']);        
    % Low skill         
    elseif strcmp(education,'lowskill') && strcmp(income,'market')
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/educ1/Individual_Market.csv']);  
    elseif strcmp(education,'lowskill') && strcmp(income,'disposable')
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/educ1/Individual_Disp.csv']);
    elseif strcmp(education,'lowskill') && strcmp(income,'disposable(family)')
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/educ1/Family_Disp.csv']);  
    % Medium Skill     
    elseif strcmp(education,'mediumskill') && strcmp(income,'market')
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/educ2/Individual_Market.csv']);   
    elseif strcmp(education,'mediumskill') && strcmp(income,'disposable')
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/educ2/Individual_Disp.csv']);
    elseif strcmp(education,'mediumskill') && strcmp(income,'disposable(family)')
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/educ2/Family_Disp.csv']);
    % High Skill     
    elseif strcmp(education,'highskill') && strcmp(income,'market')
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/educ3/Individual_Market.csv']);
    elseif strcmp(education,'highskill') && strcmp(income,'disposable')
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/educ3/Individual_Disp.csv']); 
    elseif strcmp(education,'highskill') && strcmp(income,'disposable(family)')
        file   =  char(['./sample_baseline/moments/autocov/cohort',num2str(cohort),'/educ3/Family_Disp.csv']);
    end;

    Temp      = importdata(file);        
    AutoCov   = Temp.data;
    
    %% -------- LIFE-CYCLE PROFILE 1st ORDER AUTOCORRELATION COEFFICIENT ------

    % Age Range : Levels  
    [age_min,age_max] = fCohortAgeRange(cohort);
    age = age_min : age_max - 1;         % -1 as kappa not defined for kappa(age_max)

    % Coeffficient of 1st order autocorrelation
    for i = 1:length(age)
        kappa(i) = AutoCov(i,i+1)/(sqrt(AutoCov(i,i))*sqrt(AutoCov(i+1,i+1)));
    end;


    % Export results
    for i=1:length(age)
        CellArray(i,:) = {cohort,education,income,age(i),kappa(i)};
    end;

    cell2csv(['./sample_baseline/moments/autocov/AutoCorrCoeff_',(education),'_',(income),'_',num2str(cohort),'.csv'],...
             CellArray);
     
     
elseif length(cohort) > 1         % average across cohorts 
    
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
    
    % Coeffficient of 1st order autocorrelation
    for i = 1:size(AutoCov,1) - 1            % -1 as kappa(age_max) not defined
        kappa(i) = AutoCov(i,i+1)/(sqrt(AutoCov(i,i))*sqrt(AutoCov(i+1,i+1)));
    end;


    % Export results
    age = min(age_min) : max(age_max) - 1;
    for i=1:length(age)
        CellArray(i,:) = {'19251964',education,income,age(i),kappa(i)};
    end;

    cell2csv(['./sample_baseline/moments/autocov/AutoCorrCoeff_',(education),'_',(income),'_19251964.csv'],...
             CellArray);
    
    
end;

end



    
    
    
    




        


