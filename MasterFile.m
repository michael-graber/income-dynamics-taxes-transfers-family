% NOTE: to serially execute: comment out all 'exit' and run
%       to parallel execute using many Matlab instances and execute by sections 


%% Baseline Model and Baseline Sample

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'market'            ,'sample_baseline','on')
    main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'disposable'        ,'sample_baseline','on')
    main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'disposable(family)','sample_baseline','on')
end;

matlabpool close

exit

%% Baseline Modeland Bootstrap Baseline Samples I

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    for sample = 1:35
        main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'market'            ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'disposable'        ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'disposable(family)',['bssample_',num2str(sample)],'on')
    end;    
end;

matlabpool close

exit

%% Baseline Modeland Bootstrap Baseline Samples II

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    for sample = 36:70
        main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'market'            ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'disposable'        ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'disposable(family)',['bssample_',num2str(sample)],'on')
    end;    
end;

matlabpool close

exit

%% Baseline Model and Baseline Sample - separately by Cohorts

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    for cohort = 1925:1964
        main_estimation(cohort,'model_baseline',char(education(eduindex)),'market'            ,'sample_baseline','on')
        main_estimation(cohort,'model_baseline',char(education(eduindex)),'disposable'        ,'sample_baseline','on')
        main_estimation(cohort,'model_baseline',char(education(eduindex)),'disposable(family)','sample_baseline','on')
    end;
end;

matlabpool close

exit

%% Baseline Model and One Basic Sample

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'market'            ,'sample_oneBasic','on')
    main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'disposable'        ,'sample_oneBasic','on')
    main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'disposable(family)','sample_oneBasic','on')
end;

matlabpool close

exit

%% Model with Heterogenous Profiles and Baseline Sample

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    main_estimation((1925:1964)','model_profile',char(education(eduindex)),'market'            ,'sample_baseline','on')
    main_estimation((1925:1964)','model_profile',char(education(eduindex)),'disposable'        ,'sample_baseline','on')
    main_estimation((1925:1964)','model_profile',char(education(eduindex)),'disposable(family)','sample_baseline','on')
end;

matlabpool close

exit

%% Model with Heterogenous Profiles - Bootstrap Baseline Samples I

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    for sample = 1:35
        main_estimation((1925:1964)','model_profile',char(education(eduindex)),'market'            ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_profile',char(education(eduindex)),'disposable'        ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_profile',char(education(eduindex)),'disposable(family)',['bssample_',num2str(sample)],'on')
    end;    
end;

exit

%% Model with Heterogenous Profiles - Bootstrap Baseline Samples II

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    for sample = 36:70
        main_estimation((1925:1964)','model_profile',char(education(eduindex)),'market'            ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_profile',char(education(eduindex)),'disposable'        ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_profile',char(education(eduindex)),'disposable(family)',['bssample_',num2str(sample)],'on')
    end;    
end;

exit

%% Model with Constant Variances and Baseline Sample

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    main_estimation((1925:1964)','model_constant',char(education(eduindex)),'market'            ,'sample_baseline','on')
    main_estimation((1925:1964)','model_constant',char(education(eduindex)),'disposable'        ,'sample_baseline','on')
    main_estimation((1925:1964)','model_constant',char(education(eduindex)),'disposable(family)','sample_baseline','on')
end;

matlabpool close

exit

%% Model with Constant Variances and Bootstrap Baseline Samples I

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    for sample = 1:35
        main_estimation((1925:1964)','model_constant',char(education(eduindex)),'market'            ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_constant',char(education(eduindex)),'disposable'        ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_constant',char(education(eduindex)),'disposable(family)',['bssample_',num2str(sample)],'on')
    end;    
end;

matlabpool close

exit

%% Model with Constant Variances and Bootstrap Baseline Samples II

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    for sample = 36:70
        main_estimation((1925:1964)','model_constant',char(education(eduindex)),'market'            ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_constant',char(education(eduindex)),'disposable'        ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_constant',char(education(eduindex)),'disposable(family)',['bssample_',num2str(sample)],'on')
    end;    
end;

matlabpool close

exit

%% Baseline Model without MA and Baseline Sample

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    main_estimation((1925:1964)','model_noMA',char(education(eduindex)),'market'            ,'sample_baseline','on')
    main_estimation((1925:1964)','model_noMA',char(education(eduindex)),'disposable'        ,'sample_baseline','on')
    main_estimation((1925:1964)','model_noMA',char(education(eduindex)),'disposable(family)','sample_baseline','on')
end;

matlabpool close

exit

%% Baseline Model without MA and Bootstrap Baseline Samples I

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    for sample = 1:35
        main_estimation((1925:1964)','model_noMA',char(education(eduindex)),'market'            ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_noMA',char(education(eduindex)),'disposable'        ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_noMA',char(education(eduindex)),'disposable(family)',['bssample_',num2str(sample)],'on')
    end;    
end;

matlabpool close

exit

%% Baseline Model without MA and Bootstrap Baseline Samples II

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    for sample = 36:70
        main_estimation((1925:1964)','model_noMA',char(education(eduindex)),'market'            ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_noMA',char(education(eduindex)),'disposable'        ,['bssample_',num2str(sample)],'on')
        main_estimation((1925:1964)','model_noMA',char(education(eduindex)),'disposable(family)',['bssample_',num2str(sample)],'on')
    end;    
end;

matlabpool close

exit


%% Baseline Model and Dual Sample

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    main_estimation((1925:1964)','model_baseline',char(education(eduindex)),'disposable(family)','sample_dual','on')
end;

matlabpool close

exit

%% Model with Constant Variances and No MA 

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    main_estimation((1925:1964)','model_constant_noMA',char(education(eduindex)),'market'            ,'sample_baseline','on')
    main_estimation((1925:1964)','model_constant_noMA',char(education(eduindex)),'disposable'        ,'sample_baseline','on')
    main_estimation((1925:1964)','model_constant_noMA',char(education(eduindex)),'disposable(family)','sample_baseline','on')
end;

matlabpool close

exit

%% Dual Earner Model I

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    main_estimation((1925:1964)','model_dual',char(education(eduindex)),'market'            ,'sample_dual','off')
end    

matlabpool close

exit

%% Dual Earner Model II

matlabpool open 4
education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    main_estimation((1925:1964)','model_dual',char(education(eduindex)),'disposable','sample_dual','off')
end;

matlabpool close

exit

%% 1st Order Autocoerrelation Coefficient - Data

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    main_1storderautocorrelation((1925:1964)',char(education(eduindex)),'market')
    main_1storderautocorrelation((1925:1964)',char(education(eduindex)),'disposable')
    main_1storderautocorrelation((1925:1964)',char(education(eduindex)),'disposable(family)')
end;

matlabpool close

%% Generating Moments for Model Fit: Age profiles of variance and 1-lag covariance of growth rates

% Note: This can only be executed after the model has been solved!

matlabpool open 4

education = {'pooled','lowskill','mediumskill','highskill'};

parfor eduindex = 1:4
    main_modelfit_growthrate_data((1925:1964)','model_baseline',char(education(eduindex)),'market','sample_baseline')
    main_modelfit_growthrate_data((1925:1964)','model_baseline',char(education(eduindex)),'disposable','sample_baseline')
    main_modelfit_growthrate_data((1925:1964)','model_baseline',char(education(eduindex)),'disposable(family)','sample_baseline')
end;

matlabpool close

exit
 