function [] = main_modelfit_growthrate_data(cohort,model,education,income,sample)

Param.cohort    = cohort;
Param.education = education;
Param.income    = income;
Param.sample    = sample;
Param.model     = model;

%% Empirical Counterparts

% Load model-specific files and make sample-specific folders accessible:
restoredefaultpath;
workingDir = '/data/uctpmgr/BitBucket/BlundellGraberMogstad'; cd(workingDir)
addpath(genpath('tools'));                  % Tools

% Load the age profile of the variance and 1-lag covariance of income growth rates
[AutoCovMale,~,~,~,age] = fImportData(1,[],Param);
var_delta_y = diag(AutoCovMale);
cov_delta_y = [diag(AutoCovMale,1);NaN];

% Load the age profile of the variance in levels
var_y = fCalculateVar_y(Param.cohort,Param.education,Param.income); 


%% Theoretical Counterparts

% Load Results
temp = importdata(char(['./model_baseline/results/sample_baseline_',education,'_',income,'_Average.csv']));

% Parameter Estimates (see structure of result tables)
age       = temp.data(:,1);
rho       = temp.data(1,2);
var_alpha = temp.data(1,3);
sigma2    = temp.data(:,6);
omega2    = temp.data(:,7);
theta     = temp.data(1,8);

% Calculate Variance of permanent component v
% R is a matrix: [rho^0,rho^2,rho^4,rho^6,...
%                    0 , rho^0,rho^2, ...]
% Multiplying this matrix with sigma2 and summing the columns
% gives the variance of the permanent component at a given age a.

R = diag(rho.^zeros(size(sigma2,1),1),0);
for i = 1:size(sigma2,1)-1
    R = R + diag(rho.^(i*2*ones(size(sigma2,1)-i,1)),i);
end;

var_v = sum(repmat(sigma2,1,size(sigma2,1)) .* R)';

% Calculate the variance profile of the income growth rates
var_delta_y_model = NaN * size(sigma2);

for i = 2:size(sigma2) 
    if i == 2 % as omega_a-2 = omega_a-1 by assumption.
        var_delta_y_model(i) = (rho - 1)^2 * var_v(i-1) + sigma2(i) + omega2(i) + ((theta - 1)^2) * omega2(i-1) + theta^2 * omega2(i-1);
    else
        var_delta_y_model(i) = (rho - 1)^2 * var_v(i-1) + sigma2(i) + omega2(i) + ((theta - 1)^2) * omega2(i-1) + theta^2 * omega2(i-2);
    end;
end;

% Calculate the covariance profile of the income growth rates
cov_delta_y_model = NaN * size(sigma2);

for i = 2:size(sigma2) 
        cov_delta_y_model(i) = (rho - 1)^2 * rho * var_v(i-1) + (rho - 1) * sigma2(i) + (theta - 1) * omega2(i) - theta * (theta-1) * omega2(i-1);
end;

% Calculate the variance profile in levels
var_y_model = NaN * size(sigma2);

for i = 1:size(sigma2)
    if i == 1 % omega2(i) == omega2(i-1) by restriction
        var_y_model(i) = var_alpha + var_v(i) + omega2(i) + (theta^2) * omega2(i);
    else
         var_y_model(i) = var_alpha + var_v(i) + omega2(i) + (theta^2) * omega2(i-1);
    end;     
end;

%% Export Model Fit

% Export as csv table
for i=1:length(age)-1 % as last cov not defined
    CellArray(i,:) = {'19251964',education,income,sample,age(i),var_delta_y(i),var_delta_y_model(i), cov_delta_y(i), cov_delta_y_model(i),var_y(i),var_y_model(i)};    
end;

% Replace NaN's with empty cells (makes it easier to deal with in Stata)
CellArray(cellfun(@(x) any(isnan(x)),CellArray)) = {''};

cell2csv(['./output/stata/modelfit/Cov_delta_y_',(education),'_',(income),'_19251964.csv'],CellArray);










end