
% Trends: The idea is to get a trend number which defines trend re-occurence
states = 2;
%first, how many possible states do we track? lowest is boolean=2
%a trend is represented as a number in the base of the number of states
%the most significant bit is (oldest or latest or determined by some external quantity)?
%note the trend value just before a false (or desired state to predict)
%if the trend value (false) occurs more than once consecutively, note and use same trend value but with a ride value (integer) for how long it rides.

%clear vars

%% read input from file
trend_array = csvread('gtb.csv');
%trend_array = [1,1; 2,2; 3,1; 5,1; 10,1];

%% find lowest difference between stamps
diff_min = diff_minimum(trend_array);

%% fill in missings in array
trend_new = fill_missing(trend_array, diff_min, 0);
