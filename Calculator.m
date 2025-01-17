% Create the figure window
f = figure('Name', 'Scientific Calculator', 'NumberTitle', 'off', ...
           'Position', [300, 300, 400, 500]);

% Create the text box (display)
t = uicontrol('Style', 'text', 'String', '', 'Position', [10, 450, 380, 40], ...
              'FontSize', 20, 'HorizontalAlignment', 'right');

% Define button properties
buttonWidth = 80;
buttonHeight = 60;
xOffset = 10;
yOffset = 380;
xSpacing = 10;
ySpacing = 10;

% Define the button labels
buttons = {'7', '8', '9', '/';
           '4', '5', '6', '*';
           '1', '2', '3', '-';
           'C', '0', '=', '+'};

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
    % Get the current text in the display
    currentText = get(displayBox, 'String'); 
    
    % Handle button actions
    if strcmp(buttonValue, 'C')
        % Clear the display
        set(displayBox, 'String', '');
    elseif strcmp(buttonValue, '=')
        % Evaluate the expression
        try
            result = eval(currentText); % Evaluate the expression
            set(displayBox, 'String', num2str(result));
        catch
            set(displayBox, 'String', 'Error'); % Display error if invalid
        end
    else
        % Append the button's value to the display
        set(displayBox, 'String', [currentText, buttonValue]);
    end
end

% Wait for user interaction
uiwait(f);
