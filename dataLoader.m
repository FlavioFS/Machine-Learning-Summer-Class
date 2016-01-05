function [xData, yArray] = dataLoader(filePath, delimiter, shuffle)
	% Reads the file and returns the data matrix and the values array
	columnCount = 0;
	dataFile = fopen(filePath, 'r');

	% First line
	line = fgetl(dataFile);
	if (isempty(line))
		xData  = [];
		yArray = [];
		return;
	else
		line = strsplit(line, delimiter);       % Line String to String Array
		line = line(~cellfun('isempty', line)); % Removes blank elements
		columnCount = size(line(1,:))(1,2);		% The second element of size of line (1 x rowCount)

		xData  = [line(1:columnCount-1)];
		yArray = [line(1, columnCount)];
	end

	% Several lines
	while ~feof(dataFile)
		line = fgetl(dataFile);
		if (isempty(line))
			break;
		else
			line = strsplit(line, delimiter);       % Line String to String Array
			line = line(~cellfun('isempty', line)); % Removes blank elements

			xData  = [xData; line(1:columnCount-1)];
			yArray = [yArray; line(1, columnCount)];
		end
	end

	% Shuffling
	if (nargin > 2)
		newOrder = randperm(size(yArray,1));
		xData  = xData(newOrder, :);
		yArray = yArray(newOrder, :);
	end
end