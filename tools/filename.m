function [fileMale,fileSpouse,fileCross] = filename(Param,cohort,rhoMale,rhoSpouse)

% Specify path to correct file that contains the relevant matrix of moments

 if strcmp(Param.model,'model_baseline')  || strcmp(Param.model,'model_constant') ||...
    strcmp(Param.model,'model_constant_noMA') || strcmp(Param.model,'model_noMA') || ...]
    strcmp(Param.model,'model_profile')

 if strwcmp(Param.sample,'bssample_*') % bootstrap samples of baseline sample
     
      % Pooled
    if  strcmp(Param.education,'pooled') && strcmp(Param.income,'market')     
        fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/_all/Individual_Market',num2str(rhoMale*1000),'.csv']);
        fileSpouse = '';
        fileCross  = '';
    elseif strcmp(Param.education,'pooled') && strcmp(Param.income,'disposable')
         fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/_all/Individual_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'pooled') && strcmp(Param.income,'disposable(family)')
         fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/_all/Family_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    
    % Low skill     
    elseif strcmp(Param.education,'lowskill') && strcmp(Param.income,'market')
         fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/educ1/Individual_Market',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'lowskill') && strcmp(Param.income,'disposable')
         fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/educ1/Individual_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'lowskill') && strcmp(Param.income,'disposable(family)')
         fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/educ1/Family_Disp',num2str(rhoMale*1000),'.csv']);  
         fileSpouse = '';
         fileCross  = '';
    
    % Medium Skill     
    elseif strcmp(Param.education,'mediumskill') && strcmp(Param.income,'market')
         fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/educ2/Individual_Market',num2str(rhoMale*1000),'.csv']);   
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'mediumskill') && strcmp(Param.income,'disposable')
         fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/educ2/Individual_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'mediumskill') && strcmp(Param.income,'disposable(family)')
         fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/educ2/Family_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    
    % High Skill     
    elseif strcmp(Param.education,'highskill') && strcmp(Param.income,'market')
         fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/educ3/Individual_Market',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'highskill') && strcmp(Param.income,'disposable')
         fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/educ3/Individual_Disp',num2str(rhoMale*1000),'.csv']); 
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'highskill') && strcmp(Param.income,'disposable(family)')
         fileMale   =  char(['./sample_baseline/bootstrap_moments/',(Param.sample),'/cohort',num2str(cohort),'/educ3/Family_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
         
    end;
     
 else     
    
    % Pooled
    if  strcmp(Param.education,'pooled') && strcmp(Param.income,'market')     
        fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/_all/Individual_Market',num2str(rhoMale*1000),'.csv']);
        fileSpouse = '';
        fileCross  = '';
    elseif strcmp(Param.education,'pooled') && strcmp(Param.income,'disposable')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/_all/Individual_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'pooled') && strcmp(Param.income,'disposable(family)')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/_all/Family_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    
    % Low skill     
    elseif strcmp(Param.education,'lowskill') && strcmp(Param.income,'market')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ1/Individual_Market',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'lowskill') && strcmp(Param.income,'disposable')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ1/Individual_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'lowskill') && strcmp(Param.income,'disposable(family)')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ1/Family_Disp',num2str(rhoMale*1000),'.csv']);  
         fileSpouse = '';
         fileCross  = '';
    
    % Medium Skill     
    elseif strcmp(Param.education,'mediumskill') && strcmp(Param.income,'market')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ2/Individual_Market',num2str(rhoMale*1000),'.csv']);   
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'mediumskill') && strcmp(Param.income,'disposable')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ2/Individual_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'mediumskill') && strcmp(Param.income,'disposable(family)')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ2/Family_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    
    % High Skill     
    elseif strcmp(Param.education,'highskill') && strcmp(Param.income,'market')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ3/Individual_Market',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'highskill') && strcmp(Param.income,'disposable')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ3/Individual_Disp',num2str(rhoMale*1000),'.csv']); 
         fileSpouse = '';
         fileCross  = '';
    elseif strcmp(Param.education,'highskill') && strcmp(Param.income,'disposable(family)')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ3/Family_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = '';
         fileCross  = '';
         
    end;
 end;
    
 elseif strcmp(Param.model,'model_dual')
     
      % Pooled
    if  strcmp(Param.education,'pooled') && strcmp(Param.income,'market')     
        fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/_all/Male_Market',num2str(rhoMale*1000),'.csv']);
        fileSpouse =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/_all/Spouse_Market',num2str(rhoSpouse*1000),'.csv']);
        fileCross  =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/_all/Male_Spouse_Market',num2str(rhoMale*1000),num2str(rhoSpouse*1000),'.csv']);
    elseif strcmp(Param.education,'pooled') && strcmp(Param.income,'disposable')
         fileMale   = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/_all/Male_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/_all/Spouse_Disp',num2str(rhoSpouse*1000),'.csv']);
         fileCross  = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/_all/Male_Spouse_Disp',num2str(rhoMale*1000),num2str(rhoSpouse*1000),'.csv']);
    
    % Low skill     
    elseif strcmp(Param.education,'lowskill') && strcmp(Param.income,'market')
         fileMale   = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ1/Male_Market',num2str(rhoMale*1000),'.csv']);
         fileSpouse = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ1/Spouse_Market',num2str(rhoSpouse*1000),'.csv']);
         fileCross  = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ1/Male_Spouse_Market',num2str(rhoMale*1000),num2str(rhoSpouse*1000),'.csv']);
    elseif strcmp(Param.education,'lowskill') && strcmp(Param.income,'disposable')
         fileMale   = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ1/Male_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ1/Spouse_Disp',num2str(rhoSpouse*1000),'.csv']);
         fileCross  = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ1/Male_Spouse_Disp',num2str(rhoMale*1000),num2str(rhoSpouse*1000),'.csv']);
    
    % Medium Skill     
    elseif strcmp(Param.education,'mediumskill') && strcmp(Param.income,'market')
         fileMale   = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ2/Male_Market',num2str(rhoMale*1000),'.csv']);   
         fileSpouse = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ2/Spouse_Market',num2str(rhoSpouse*1000),'.csv']);   
         fileCross  = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ2/Male_Spouse_Market',num2str(rhoMale*1000),num2str(rhoSpouse*1000),'.csv']);   
    elseif strcmp(Param.education,'mediumskill') && strcmp(Param.income,'disposable')
         fileMale   = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ2/Male_Disp',num2str(rhoMale*1000),'.csv']);
         fileSpouse = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ2/Spouse_Disp',num2str(rhoSpouse*1000),'.csv']);
         fileCross  = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ2/Male_Spouse_Disp',num2str(rhoMale*1000),num2str(rhoSpouse*1000),'.csv']);
    
   % High Skill     
    elseif strcmp(Param.education,'highskill') && strcmp(Param.income,'market')
         fileMale   = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ3/Male_Market',num2str(rhoMale*1000),'.csv']);
         fileSpouse = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ3/Spouse_Market',num2str(rhoSpouse*1000),'.csv']);
         fileCross  = char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ3/Male_Spouse_Market',num2str(rhoMale*1000),num2str(rhoSpouse*1000),'.csv']);
    elseif strcmp(Param.education,'highskill') && strcmp(Param.income,'disposable')
         fileMale   =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ3/Male_Disp',num2str(rhoMale*1000),'.csv']); 
         fileSpouse =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ3/Spouse_Disp',num2str(rhoSpouse*1000),'.csv']); 
         fileCross  =  char(['./',(Param.sample),'/moments/cohort',num2str(cohort),'/educ3/Male_Spouse_Disp',num2str(rhoMale*1000),num2str(rhoSpouse*1000),'.csv']); 
    
    end;
   
end;

end