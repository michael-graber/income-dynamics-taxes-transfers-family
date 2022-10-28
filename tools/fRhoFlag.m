function rho_flag = fRhoFlag(rhoMale,rhoSpouse,Param)

if strcmp(Param.model,'model_baseline') || strcmp(Param.model,'model_constant') ||...
   strcmp(Param.model,'model_constant_noMA') || strcmp(Param.model,'model_noMA') || ...
   strcmp(Param.model,'model_profile')
    
    rho_flag = genvarname(['rhoMale_' num2str(rhoMale*1000)]);
    
else
    
    rho_flag = genvarname(['rhoMale_' num2str(rhoMale*1000) 'rhoSpouse_' num2str(rhoSpouse*1000)]);
    
end;
    
end