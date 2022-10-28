function fScreenOutput(Param,rhoMale,rhoSpouse)

display('================================================================')

if length(Param.cohort) == 1
    display(['Cohort ', num2str(Param.cohort)])
else
    display('Average Cohort Effects')
end;    

display(['model = ',Param.model])
display(['income = ',Param.income])
display(['education = ',Param.education])


if strcmp(Param.model,'model_baseline') || strcmp(Param.model,'model_constant') ||...
   strcmp(Param.model,'model_constant_noMA') || strcmp(Param.model,'model_noMA') || ...
   strcmp(Param.model,'model_profile')
    
   display(['rhoMale = ',num2str(rhoMale)])

else
    
   display(['rhoMale = ',num2str(rhoMale)])
   display(['rhoSpouse = ',num2str(rhoSpouse)])
    
end;

display('================================================================')
end