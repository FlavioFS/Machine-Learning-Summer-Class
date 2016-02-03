%%%% =========================================================================== %%%%
%%%%                               Initial Settings                              %%%%
%%%% =========================================================================== %%%%

%% Loading
load teste.data;

%% Sizes
TOTAL_SAMPLES = size(teste(:,1))(1,1);	% Number of lines of the first column
COLUMNS_LOAD  = size(teste(1,:))(1,2);	% Number of columns of the first line




%%%% =========================================================================== %%%%
%%%%                                  Definitions                                %%%%
%%%% =========================================================================== %%%%

%% CenterGen: Creates <centerCount> centers filled with random elements in the sample range
function output = CenterGen(centerCount, samples)
	columnCount = size(samples(1,:))(1,2);
	lambda = rand(centerCount, columnCount);		% Linear combination factor
	output = zeros(centerCount, columnCount);
	minimums = [];
	maximums = [];

	coluna = [];
	
	% Calculating the limits
	for columnIterator = 1 : columnCount
		minimums = [minimums, min(samples(:, columnIterator))];
		maximums = [maximums, max(samples(:, columnIterator))];
	end

	% Lerping the random centers
	for centerIterator = 1 : centerCount
		for columnIterator = 1 : columnCount
			output(centerIterator, columnIterator) = ...
				minimums(1, columnIterator) * lambda(centerIterator, columnIterator) + ...
				maximums(1, columnIterator) * (1 - lambda(centerIterator, columnIterator));
		end
	end
end

%% CalcDistances: Calculate all the distances
function [outputs] = CalcDistances(samples, centers)
	centerAmount = size(centers(:,1))(1,1);
	sampleAmount = size(samples(:,1))(1,1);
	outputs = zeros(sampleAmount, centerAmount);
	
	for sampleIterator = 1 : sampleAmount
		for centerIterator = 1 : centerAmount
			outputs(sampleIterator, centerIterator) = norm(centers(centerIterator, :) - samples(sampleIterator, :));
		end
	end
end

%% GetGroupIndexes: Returns the group of elements that belong to the center <i>
function [outputs] = GetGroupIndexes(i, distances)
	sampleAmount = size(distances(:,1))(1,1);
	outputs = [];
	
	for sampleIterator = 1 : sampleAmount
		[lowest, group] = min(distances(sampleIterator, :));
		if group == i
			outputs = [outputs sampleIterator];
		end
	end
end

%% GetGroupDistances: Returns a list of distances to each center
function [outputs] = GetGroupDistances(groupIndexes, distancesToCenter)
	outputs = [];
	
	% Empty group
	if size(groupIndexes)(1,1) == 0
		return
	end

	groupSize = size(groupIndexes(:,1))(1,1);

	for groupIterator = 1 : groupSize
		outputs = [outputs distancesToCenter(groupIndexes, 1)];
	end
end

%% UpdatedCenters: Retuns the new value of the center for the group
function output = UpdatedCenter(groupIndexes, samples)
	coordCount = size(samples(1,:))(1,2);
	output = zeros(1, coordCount);

	% Empty group
	if size(groupIndexes)(1,1) == 0
		return
	end

	groupSize = size(groupIndexes(1,:))(1,2);
	
	for groupIterator = 1 : groupSize
		output += samples(groupIndexes(1, groupIterator), :);
	end

	output /= groupSize;
end

%% SumDistances: The sum of distances between a center and its elements
function output = SumDistances(group, distancesToCenter)
	output = 0;

	% Empty group
	if size(group)(1,1) == 0
		return
	end

	groupSize = size(group(1,:))(1,2);

	for groupIterator = 1: groupSize
		output += distancesToCenter(group(1, groupIterator), 1);
	end
end




%%%% =========================================================================== %%%%
%%%%                                 Estimating                                  %%%%
%%%% =========================================================================== %%%%

%% How many groups?
MAX_CENTERS = 6;	% Calculates from 1 to this value
STEPS = 5;			% How many steps when converging?

% groups = ones(TOTAL_SAMPLES, 1);							% This sample belongs to which group?
samples = teste;											% Matrix os samples, 1 sample per line
sourceCenters = CenterGen(MAX_CENTERS, samples);			% Coordinates of centers
globalSum = zeros(MAX_CENTERS, 1);							% This is used to evaluate the correct amount of centers

figure();	
for centersUsed = 1 : MAX_CENTERS							% Applies the algorithm to several amounts of centers
	
	% Updates the centers some times to converge
	centers = sourceCenters(1:centersUsed, :);
	for step = 1 : STEPS									
		
		distances = CalcDistances(samples, centers);		% Center-Sample distances for each pair
		for centerIterator = 1 : centersUsed				% Some operations with each center

			% Gets the group, the new center position
			% and the sum of the distances for this group
			Gi = GetGroupIndexes(centerIterator, distances(:, 1:centersUsed));
			centers(centerIterator, :) = UpdatedCenter(Gi, samples);

		end
	end

	% Evaluates the result after the convergence
	% printf('---------------------------- centers: %d ---------------------------- \n', centersUsed);
	globalSum(centersUsed, 1) = 0;
	for centerIterator = 1 : centersUsed
		Gi = GetGroupIndexes(centerIterator, distances);
		globalSum(centersUsed, 1) += SumDistances(Gi, distances(:, centerIterator));

		distances = CalcDistances(samples, centers);
		GiDist = GetGroupDistances(Gi, distances(:, centerIterator));
		
		% printf('----- centerIterator: %d ----- \n', centerIterator);
		% save results.mat Gi;			input('Gi: ');
		% save results.mat GiDist;		input('GiDist: ');
		% save results.mat globalSum;		input('globalSum: ');
		% save results.mat distances;		input('distances: ');
		% save distances.mat distances;
		% printf('---------------------------- G%d ---------------------------- \n', centerIterator);
		% disp(Gi);
	end
	
	plot(globalSum, 'ro',...
	     'LineWidth', 1,...
	     'MarkerSize', 5,...
	     'MarkerEdgeColor', 'w',...
	     'MarkerFaceColor', 'r');
	hold on;
	
	set(gca, 'color', [0.3 0.3 0.3]);  							% Background color (chart area)
	set(gcf, 'color', [0.4 0.4 0.4]);  							% Background color (area outside of chart)
end