% Loading
load ex2data2.data;

% Sizes
TOTAL   = size(ex2data2(:,1))(1,1);
COLUMNS = size(ex2data2(1,:))(1,2);
breakpoint = 70;% floor(TOTAL/2);

% Adding the one for the constant term
X = ex2data2(:, 1:COLUMNS-1);
X1 = ex2data2(:, 1);
X2 = ex2data2(:, 2);
Y = ex2data2(:, COLUMNS);

%% mapFeature: function description
function output = mapThis(X1, X2)
	degree = 30;
	output = ones(size(X1(:,1)));
	for i = 1:degree
	    for j = 0:i
	        output(:, end+1) = (X1.^(i-j)).*(X2.^j);
	    end
	end
end

wow = mapThis(X1, X2);

save wow.mat wow

% function out = mappo(X1, X2)
% MAPFEATURE Feature mapping function to polynomial features
%
%   MAPFEATURE(X1, X2) maps the two input features
%   to quadratic features used in the regularization exercise.
%
%   Returns a new feature array with more features, comprising of 
%   X1, X2, X1.^2, X2.^2, X1*X2, X1*X2.^2, etc..
%
%   Inputs X1, X2 must be the same size
%
% 	degree = 30;
% 	out = ones(size(X1(:,1)));
% 	for i = 1:degree
% 	    for j = 0:i
% 	        out(:, end+1) = (X1.^(i-j)).*(X2.^j);
% 	    end
% 	end
% end
