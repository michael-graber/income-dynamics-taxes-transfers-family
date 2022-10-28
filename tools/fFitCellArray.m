function [CellArray] = fFitCellArray(Result,Param)
% This file creates a matrix of the fit containing
% the data moments for lags 0,1,2,3,4, the corresponding theoretical
% moments.

% col 1 : cohort
% col 2 : model
% col 3 : education
% col 4 : income
% col 5 : sample
% col 6 : age
% col 7 : DataMomentLag0
% col 8 : DataMomentLag1
% col 9 : DataMomentLag2
% col 10 :DataMomentLag3
% col 11 :DataMomentLag4
% col 12 :ModelMomentLag0
% col 13: ModelMomentLag1
% col 14: ModelMomentLag2
% col 15 :ModelMomentLag3
% col 16 :ModelMomentLag4

    
if length(Param.cohort) > 1
    cohort = 'Average';
else
    cohort = num2str(Param.cohort);
end;


for i=1:length(Result.age)
    CellArray(i,:) = {
                        cohort, ...
                        Param.model, ...
                        Param.education, ...
                        Param.income, ...
                        Param.sample,...
                        Result.age(i),...
                        Result.fit.DataMomentLag0(i), ...
                        Result.fit.DataMomentLag1(i), ...
                        Result.fit.DataMomentLag2(i), ...
                        Result.fit.DataMomentLag3(i), ....
                        Result.fit.DataMomentLag4(i), ...
                        Result.fit.ModelMomentsLag0(i), ...
                        Result.fit.ModelMomentsLag1(i), ...
                        Result.fit.ModelMomentsLag2(i), ...
                        Result.fit.ModelMomentsLag3(i), ....
                        Result.fit.ModelMomentsLag4(i)}; 
                        
end;

% Replace NaN's with empty cells (makes it easier to deal with in Stata)

CellArray(cellfun(@(x) any(isnan(x)),CellArray)) = {''};

end

