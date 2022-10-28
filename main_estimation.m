function [] = main_estimation(cohort,model,education,income,sample,GradFlag)
% Estimation for INCOME DYNAMICS OVER THE LIFE CYCLE
% Date:    September 2013
% Author:  Michael Graber
%
% This function takes as INPUTS:
%
% cohort : either the year (e.g. 1925) or a row-vector (1925:1964)'. In the
%          latter case the results are average cohort effects.
% model:   one of the following strings 
%          'model_baseline'
%          'model_constant'
%          'model_constant_noMA'
%          'model_noMA'
%          'model_profile'
%          'model_dual'
% education: one of the following strings:
%          'pooled'
%          'lowskill'
%          'mediumskill'
%          'highskill'
% income:  one fo the following strings:
%          'market'
%          'disposable'
%          'disposable(family)'
% sample: one of the following strings:
%          'sample_baseline'
%          'sample_oneBasic'
%          'sample_dual'
% GradFlag: one of the following strings:
%          'on': Use analyticial gradients and Hessians
%          'off': Use numerical, finite difference approximations.
%
% This function saves the results of the estimation in
% "./"model"/results/"sample"/cohort_income_education.mat"
%--------------------------------------------------------------------------

%% -------------------USER INPUT-------------------------------------------
% Here we create a structure 'Param' that collects all the necessary information
% for the estimation:

Param.cohort    = cohort;
Param.model     = model;
Param.education = education;
Param.income    = income;
Param.sample    = sample;
Param.GradFlag  = GradFlag; 

% Load model-specific files and make sample-specific folders accessible:
restoredefaultpath;
workingDir = '/data/uctpmgr/BitBucket/BlundellGraberMogstad'; cd(workingDir)
addpath(genpath('tools'));                  % Tools
addpath(genpath(['./',(Param.model)]))      % files for estimation   

% Log
if (length(Param.cohort) > 1)       
   diary(['./',(Param.model),'/results/log_',(Param.sample),'_',(Param.education),'_',(Param.income),'_Average.txt']);
   diary off;
else
   diary(['./',(Param.model),'/results/log_',(Param.sample),'_',(Param.education),'_',(Param.income),'_',(Param.cohort),'.txt']);
   diary off;  
end; 

    
%% --------------------ESTIMATION------------------------------------------

if strcmp(model,'model_baseline') || strcmp(model,'model_constant') ||...
   strcmp(model,'model_constant_noMA') || strcmp(model,'model_noMA') || ...
   strcmp(model,'model_profile')
    
    % Loop over the grid of rho   
    for rhoMale = (0.75:0.01:1)
        ResultsOnGrid.(fRhoFlag(rhoMale,[],Param)) = fEstimation(rhoMale,Param);    
    end;
    
    % find rho that yields the minimum of the objective function    
    Result = fArgMinRho(ResultsOnGrid,Param);       
        
    % export results    
    if (length(Param.cohort) > 1)           
        cell2csv(['./',(Param.model),'/results/',(Param.sample),'_',(Param.education),'_',(Param.income),'_Average.csv'],... 
                  fResultCellArray(Result,Param))       
    else
        cell2csv(['./',(Param.model),'/results/',(Param.sample),'_',(Param.education),'_',(Param.income),'_',num2str(Param.cohort),'.csv'],...
                  fResultCellArray(Result,Param))
        
    end;   
     
elseif strcmp(model,'model_dual')
    
    % Loop over the 2-dimensional grid for rho
    for rhoMale = (0.75:0.01:1)
        for rhoSpouse = (0.75:0.01:1)
          ResultsOnGrid.(fRhoFlag(rhoMale,rhoSpouse,Param)) = fEstimation(rhoMale,rhoSpouse,Param);
        end;
    end;
    
    % find combination of rho's that yield the minimum of the objective function
    Result = fArgMinRho(ResultsOnGrid,Param);
    
    % export results
    if (length(Param.cohort) > 1)       
        cell2csv(['./',(Param.model),'/results/',(Param.sample),'_',(Param.education),'_',(Param.income),'_Average.csv'],...
                 fResultCellArray(Result,Param))     
    else
        cell2csv(['./',(Param.model),'/results/',(Param.sample),'_',(Param.education),'_',(Param.income),'_',num2str(Param.cohort),'.csv'],...
                 fResultCellArray(Result,Param))
    end;    
    
end;

end



    
    
    
    




        


