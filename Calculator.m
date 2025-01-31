% Create the figure window
f = figure('Name', 'Scientific Calculator', 'NumberTitle', 'off', ...
           'Position', [200, 200, 400, 550], 'MenuBar', 'none', ...
           'Resize', 'off');

% Create the text box (display)
t = uicontrol('Style', 'text', 'String', '', 'Position', [10, 480, 380, 50], ...
              'FontSize', 20, 'HorizontalAlignment', 'right', ...
              'BackgroundColor', 'white');

% Memory variable
memoryValue = 0;
degreesMode = true; % Default to degrees mode

% Define button properties
buttonWidth = 80;
buttonHeight = 50;
xOffset = 10;
yOffset = 420;
xSpacing = 10;
ySpacing = 10;

% Define the button labels
buttons = {'sin', 'cos', 'tan', 'sqrt';
           'log', 'log10', 'exp', '^';
           '7', '8', '9', '/';
           '4', '5', '6', '*';
           '1', '2', '3', '-';
           'C', '0', '=', '+';
           'm', 'mr', 'deg/rad', '!'};

% Get number of rows and columns
[numRows, numCols] = size(buttons);

% Loop through the button matrix and create buttons
for row = 1:numRows
    for col = 1:numCols
        % Calculate position for each button
        xPos = xOffset + (col - 1) * (buttonWidth + xSpacing);
        yPos = yOffset - (row - 1) * (buttonHeight + ySpacing);
        
        % Create each button
        uicontrol('Style', 'pushbutton', 'String', buttons{row, col}, ...
                  'Position', [xPos, yPos, buttonWidth, buttonHeight], ...
                  'FontSize', 14, ...
                  'Callback', @(src, event)buttonClick(t, buttons{row, col}));
    end
end

% Define the callback function
function buttonClick(displayBox, buttonValue)
    global memoryValue degreesMode; % Access global variables

    % Get the current text in the display
    currentText = get(displayBox, 'String'); 
    
    % Handle button actions
    switch buttonValue
        case 'C'
            % Clear the display
            set(displayBox, 'String', '');
        case '='
            % Evaluate the expression
            try
                result = eval(currentText); % Evaluate the expression
                set(displayBox, 'String', num2str(result));
            catch
                set(displayBox, 'String', 'Error'); % Display error if invalid
            end
        case {'sin', 'cos', 'tan', 'sqrt', 'log', 'log10', 'exp', '^', '!'}
            % Handle scientific functions
            if isempty(currentText)
                set(displayBox, 'String', 'Error'); % Display error if no input
            else
                value = str2double(currentText);
                switch buttonValue
                    case 'sin'
                        if degreesMode
                            result = sind(value); % Use degrees
                        else
                            result = sin(value); % Use radians
                        end
                    case 'cos'
                        if degreesMode
                            result = cosd(value); % Use degrees
                        else
                            result = cos(value); % Use radians
                        end
                    case 'tan'
                        if degreesMode
                            result = tand(value); % Use degrees
                        else
                            result = tan(value); % Use radians
                        end
                    case 'sqrt'
                        result = sqrt(value);
                    case 'log'
                        result = log(value);
                    case 'log10'
                        result = log10(value);
                    case 'exp'
                        result = exp(value);
                    case '^'
                        result = str2double(currentText) ^ 2; % Square
                    case '!'
                        result = factorial(value);
                end
                set(displayBox, 'String', num2str(result));
            end
        case 'm'
            % Store current display value in memory
            if ~isempty(currentText)
                memoryValue = str2double(currentText);
            end
        case 'mr'
            % Recall memory value to display
            set(displayBox, 'String', num2str(memoryValue));
        case 'deg/rad'
            % Toggle between degrees and radians mode
            degreesMode = ~degreesMode;
            if degreesMode
                set(displayBox, 'String', 'Degrees Mode');
            else
                set(displayBox, 'String', 'Radians Mode');
            end
            pause(1); % Show mode for 1 second
            set(displayBox, 'String', '');
        otherwise
            % Append the button's value to the display
            set(displayBox, 'String', [currentText, buttonValue]);
    end
end

% Wait for user interaction
uiwait(f);