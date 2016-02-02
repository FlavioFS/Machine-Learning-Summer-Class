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
	output = rand(centerCount, coordCount) * 7;
end



%%%% =========================================================================== %%%%
%%%%                                 Estimating                                  %%%%
%%%% =========================================================================== %%%%

%% How many groups?
MAX_CENTERS = 4;
groups = ones(TOTAL_SAMPLES, 1);												% This sample belongs to which group?

for centersUsed = 1 : MAX_CENTERS
	centerPositions = CenterGen(centersUsed, COLUMNS_LOAD);						% Generatins centers
	% previousGlobalSumDistances = 0;											% The sum above one step before
	distances = zeros(TOTAL_SAMPLES, centersUsed);								% Distance between the sample i and the center j
	
	figure ();
	% Converge in several steps
	for step = 1 : 5
		sumDistances = zeros(centersUsed, 1);									% The sums of the distances between centers and their elements
		newCenters = zeros(centersUsed, 2);
		globalSumDistances = 0;													% The sum of all center-element distances

		% One Pass for each sample updating the distances and the groups
		for sampleIndex = 1 : TOTAL_SAMPLES										% For all samples
			for centerIndex = 1 : centersUsed									% Calculates distance to each center
				distances(sampleIndex, centerIndex) = norm(centerPositions(centerIndex, :) - teste(sampleIndex, :));
			end

			% Updates the group at which this sample belongs: groups(sampleIndex, 1)
			[smallest, groups(sampleIndex, 1)] = min(distances(sampleIndex, :));

			% Increases the sum for the respective group
			sumDistances(groups(sampleIndex, 1), 1) += distances(sampleIndex, groups(sampleIndex, 1));
			globalSumDistances += distances(sampleIndex, groups(sampleIndex, 1));

			% Updates the center and the element count
			newCenters(groups(sampleIndex, 1), 1) += sumDistances(groups(sampleIndex, 1), 1);
			newCenters(groups(sampleIndex, 1), 2)++;
		end

		% Updates the centers
		for centerIndex = 1 : centersUsed
			if newCenters(2) ~= 0
				centerPositions(centerIndex) = newCenters(1) / newCenters(2);
			end
		end

		% printf('step: %d - centers: %d\n'	, step, centersUsed);

		% waitforbuttonpress();
	end


	% Plotting the convergence
	for centerIndex = 1 : centersUsed
		if rem(centerIndex, 4) == 0
			plot(centerPositions(centerIndex, 1:4), 'ro',...
			     'LineWidth', 1,...
			     'MarkerSize', 5,...
			     'MarkerEdgeColor', 'w',...
			     'MarkerFaceColor', 'r');
			hold on;
		elseif rem(centerIndex, 4) == 1
			plot(centerPositions(centerIndex, 1:2), 'go',...
			     'LineWidth', 1,...
			     'MarkerSize', 5,...
			     'MarkerEdgeColor', 'w',...
			     'MarkerFaceColor', 'g');
			hold on;
		elseif rem(centerIndex, 4) == 2
			plot(centerPositions(centerIndex, 1:2), 'co',...
			     'LineWidth', 1,...
			     'MarkerSize', 5,...
			     'MarkerEdgeColor', 'w',...
			     'MarkerFaceColor', 'c');
			hold on;
		else
			plot(centerPositions(centerIndex, 1:2), 'ko',...
			     'LineWidth', 1,...
			     'MarkerSize', 5,...
			     'MarkerEdgeColor', 'w',...
			     'MarkerFaceColor', 'k');
			hold on;
		end
	end

	% for sampleIndex = 1 : TOTAL_SAMPLES
	% 	plot(teste(), 'ko',...
	% 	     'LineWidth', 1,...
	% 	     'MarkerSize', 4,...
	% 	     % 'MarkerEdgeColor', 'w',...
	% 	     'MarkerFaceColor', 'k');
	% 	hold on;
	% end

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

