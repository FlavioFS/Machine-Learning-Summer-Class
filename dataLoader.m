function [xData, yArray] = dataLoader(filePath)
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
		line = strsplit(line);                  % Line String to String Array
		line = line(~cellfun('isempty', line)); % Removes blank elements
		columnCount = length(line);

		xData  = [line(1:columnCount-1)];
		yArray = [line(1, columnCount)];
	end

	% Several lines
	while ~feof(dataFile)
		line = fgetl(dataFile);
		if (isempty(line))
			break;
		else
			line = strsplit(line);                  % Line String to String Array
			line = line(~cellfun('isempty', line)); % Removes blank elements

			xData  = [xData; line(1:columnCount-1)];
			yArray = [yArray; line(1, columnCount)];
		end
	end

	% Converts the string elements to double
	xData  = cellfun(@str2double,  xData);
	yArray = cellfun(@str2double, yArray);

end