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

%% CenterGen: Creates <centerCount> centers of <coordCount> coordinates filled with random elements inside [0, 10]
function output = CenterGen(centerCount, coordCount)
	output = rand(centerCount, coordCount) * 5 + ones(centerCount, coordCount) * 2.5;
end



%%%% =========================================================================== %%%%
%%%%                                 Estimating                                  %%%%
%%%% =========================================================================== %%%%

%% How many groups?
MAX_CENTERS = 4;
groups = ones(TOTAL_SAMPLES, 1);												% This sample belongs to which group?

figure ();
for centersUsed = 1 : MAX_CENTERS
	centerPositions = CenterGen(centersUsed, COLUMNS_LOAD);						% Generatins centers
	% previousGlobalSumDistances = 0;											% The sum above one step before
	distances = zeros(TOTAL_SAMPLES, centersUsed);								% Distance between the sample i and the center j
	globalSumDistances = zeros(centersUsed, 1);									% The sum of all center-element distances
	
	% Converge in several steps
	for step = 1 : 5
		sumDistances = zeros(centersUsed, 1);									% The sums of the distances between centers and their elements
		groupSum = zeros(centersUsed, COLUMNS_LOAD);
		groupCounters = zeros(centersUsed, 1);
		globalSumDistances(:, 1) = 0;
		

		% One Pass for each sample updating the distances and the groups
		for sampleIndex = 1 : TOTAL_SAMPLES										% For all samples
			for centerIndex = 1 : centersUsed									% Calculates distance to each center
				distances(sampleIndex, centerIndex) = norm(centerPositions(centerIndex, :) - teste(sampleIndex, :));
			end

			disp('groupSum1: ');
			disp(groupSum);
			disp('teste(sampleIndex): ');
			disp(teste(sampleIndex, :));

			% Updates the group at which this sample belongs: groups(sampleIndex, 1)
			[smallest, groups(sampleIndex, 1)] = min(distances(sampleIndex, :));

			% Increases the sum for the respective group
			sumDistances(groups(sampleIndex, 1), 1) += distances(sampleIndex, groups(sampleIndex, 1));
			globalSumDistances(centerIndex, 1) += distances(sampleIndex, groups(sampleIndex, 1));

			% Updates the center and the element count
			groupSum(groups(sampleIndex, 1), :) += teste(sampleIndex, :);
			groupCounters(groups(sampleIndex, 1), 1)++;



			disp('groupSum2: ');
			disp(groupSum);
			disp('groupCounters: ');
			disp(groupCounters);

		end

		% Updates the centers
		for centerIndex = 1 : centersUsed
			if groupCounters(centerIndex, 1) ~= 0
				centerPositions(centerIndex, :) = groupSum(centerIndex, :) / groupCounters(centerIndex, 1);
			end
		end
	end

	xplotvalues = [];
	for centerIndex = 1 : centersUsed
		xplotvalues = [xplotvalues centerIndex];
	end
	disp(xplotvalues);

	disp(globalSumDistances);
	plot(globalSumDistances, xplotvalues, 'ro',...
	     'LineWidth', 1,...
	     'MarkerSize', 5,...
	     'MarkerEdgeColor', 'w',...
	     'MarkerFaceColor', 'r');
	hold on;
	% % Plotting the convergence
	% for centerIndex = 1 : centersUsed
	% 	if rem(centerIndex, 4) == 0
	% 		plot(centerPositions(centerIndex, 1:4), 'ro',...
	% 		     'LineWidth', 1,...
	% 		     'MarkerSize', 5,...
	% 		     'MarkerEdgeColor', 'w',...
	% 		     'MarkerFaceColor', 'r');
	% 		hold on;
	% 	elseif rem(centerIndex, 4) == 1
	% 		plot(centerPositions(centerIndex, 1:2), 'go',...
	% 		     'LineWidth', 1,...
	% 		     'MarkerSize', 5,...
	% 		     'MarkerEdgeColor', 'w',...
	% 		     'MarkerFaceColor', 'g');
	% 		hold on;
	% 	elseif rem(centerIndex, 4) == 2
	% 		plot(centerPositions(centerIndex, 1:2), 'co',...
	% 		     'LineWidth', 1,...
	% 		     'MarkerSize', 5,...
	% 		     'MarkerEdgeColor', 'w',...
	% 		     'MarkerFaceColor', 'c');
	% 		hold on;
	% 	else
	% 		plot(centerPositions(centerIndex, 1:2), 'ko',...
	% 		     'LineWidth', 1,...
	% 		     'MarkerSize', 5,...
	% 		     'MarkerEdgeColor', 'w',...
	% 		     'MarkerFaceColor', 'k');
	% 		hold on;
	% 	end
	% end

	% % for sampleIndex = 1 : TOTAL_SAMPLES
	% % 	plot(teste(), 'ko',...
	% % 	     'LineWidth', 1,...
	% % 	     'MarkerSize', 4,...
	% % 	     % 'MarkerEdgeColor', 'w',...
	% % 	     'MarkerFaceColor', 'k');
	% % 	hold on;
	% % end

	set(gca, 'color', [0.3 0.3 0.3]);  % Background color (chart area)
	set(gcf, 'color', [0.4 0.4 0.4]);  % Background color (area outside of chart)
	% waitforbuttonpress();

end
% distances






%%%% =========================================================================== %%%%
%%%%                                 Estimating                                  %%%%
%%%% =========================================================================== %%%%

%% Calculating squared distances
% for i=1:TOTAL_SAMPLES
% 	for j=1:MAX_CENTERS
% 		SQRDistances(i, j) = ;
% 	end
% end

