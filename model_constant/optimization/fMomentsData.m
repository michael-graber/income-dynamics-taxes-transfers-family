function MomentsData = fMomentsData(Data)
% This function calculates the corresponding stacked vector of unique empirical monents

%% Create vectors of stacked unique empirical moments 
MomentsData = [];

for i = 0:(Data.A-1)
     MomentsData = [MomentsData;diag(Data.AutoCovMale,i)]; 
end;

end