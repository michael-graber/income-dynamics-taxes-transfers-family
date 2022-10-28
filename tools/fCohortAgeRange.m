function [age_min_cohort,age_max_cohort] = fCohortAgeRange(index_cohort)
% Author: Michael Graber
% Date: August 2013
% Note: This is the age range for the income observations (i.e. NOT after 
%       1st quasi-differencing of the income data).
%       Please edit if necessary, i.e. if you change the selection
%       criteria from the raw data.
%--------------------------------------------------------------------------

    age_min(1,1)  = 42; age_max(1,1)  = 60; % cohort 1925
    age_min(2,1)  = 41; age_max(2,1)  = 60; % cohort 1926  
    age_min(3,1)  = 40; age_max(3,1)  = 60; % cohort 1927
    age_min(4,1)  = 39; age_max(4,1)  = 60; % cohort 1928  
    age_min(5,1)  = 38; age_max(5,1)  = 60; % cohort 1929
    age_min(6,1)  = 37; age_max(6,1)  = 60; % cohort 1930  
    age_min(7,1)  = 36; age_max(7,1)  = 60; % cohort 1931
    age_min(8,1)  = 35; age_max(8,1)  = 60; % cohort 1932  
    age_min(9,1)  = 34; age_max(9,1)  = 60; % cohort 1933
    age_min(10,1) = 33; age_max(10,1) = 60; % cohort 1934  
    age_min(11,1) = 32; age_max(11,1) = 60; % cohort 1935
    age_min(12,1) = 31; age_max(12,1) = 60; % cohort 1936  
    age_min(13,1) = 30; age_max(13,1) = 60; % cohort 1937
    age_min(14,1) = 29; age_max(14,1) = 60; % cohort 1938  
    age_min(15,1) = 28; age_max(15,1) = 60; % cohort 1939
    age_min(16,1) = 27; age_max(16,1) = 60; % cohort 1940
    age_min(17,1) = 26; age_max(17,1) = 60; % cohort 1941
    age_min(18,1) = 25; age_max(18,1) = 60; % cohort 1942  
    age_min(19,1) = 25; age_max(19,1) = 60; % cohort 1943
    age_min(20,1) = 25; age_max(20,1) = 60; % cohort 1944  
    age_min(21,1) = 25; age_max(21,1) = 60; % cohort 1945
    age_min(22,1) = 25; age_max(22,1) = 60; % cohort 1946  
    age_min(23,1) = 25; age_max(23,1) = 59; % cohort 1947
    age_min(24,1) = 25; age_max(24,1) = 58; % cohort 1948  
    age_min(25,1) = 25; age_max(25,1) = 57; % cohort 1949
    age_min(26,1) = 25; age_max(26,1) = 56; % cohort 1950  
    age_min(27,1) = 25; age_max(27,1) = 55; % cohort 1951
    age_min(28,1) = 25; age_max(28,1) = 54; % cohort 1952  
    age_min(29,1) = 25; age_max(29,1) = 53; % cohort 1953
    age_min(30,1) = 25; age_max(30,1) = 52; % cohort 1954  
    age_min(31,1) = 25; age_max(31,1) = 51; % cohort 1955
    age_min(32,1) = 25; age_max(32,1) = 50; % cohort 1956
    age_min(33,1) = 25; age_max(33,1) = 49; % cohort 1957  
    age_min(34,1) = 25; age_max(34,1) = 48; % cohort 1958
    age_min(35,1) = 25; age_max(35,1) = 47; % cohort 1959  
    age_min(36,1) = 25; age_max(36,1) = 46; % cohort 1960
    age_min(37,1) = 25; age_max(37,1) = 45; % cohort 1961  
    age_min(38,1) = 25; age_max(38,1) = 44; % cohort 1962
    age_min(39,1) = 25; age_max(39,1) = 43; % cohort 1963
    age_min(40,1) = 25; age_max(40,1) = 42; % cohort 1964
    
    % Output
    age_min_cohort = age_min(index_cohort-1924,1);
    age_max_cohort = age_max(index_cohort-1924,1);



end

