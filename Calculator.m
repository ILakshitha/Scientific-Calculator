function scientific_calculator()
    % Create the main figure window
    f = figure('Position', [100, 100, 500, 700], ...
               'Name', 'Scientific Calculator', ...
               'NumberTitle', 'off', ...
               'Color', [0.1, 0.1, 0.1]);

    % Display screen
    display = uicontrol('Style', 'text', ...
                        'Position', [20, 600, 460, 60], ...
                        'FontSize', 20, ...
                        'HorizontalAlignment', 'right', ...
                        'BackgroundColor', [0.3, 0.3, 0.3], ...
                        'ForegroundColor', 'white', ...
                        'String', '0');

    % Define button layout
    button_layout = {
         'π', '!', '(', ')', '%', 'CE';
         'sin', 'ln', '7', '8', '9', '/';
         'cos', 'log', '4', '5', '6', '*';
         'tan', '√', '1', '2', '3', '-';
         'EXP', '^', '0', '.', '=', '+'
    };

    % Button colors and dimensions
    button_bg_color = [0.15, 0.15, 0.15];
    button_fg_color = 'white';
    button_width = 60;
    button_height = 40;
    button_spacing = 10;

    % Create buttons dynamically
    for row = 1:size(button_layout, 1)
        for col = 1:size(button_layout, 2)
            if ~isempty(button_layout{row, col})
                uicontrol('Style', 'pushbutton', ...
                          'String', button_layout{row, col}, ...
                          'Position', [20 + (col-1)*(button_width + button_spacing), ...
                                       600 - row*(button_height + button_spacing), ...
                                       button_width, button_height], ...
                          'FontSize', 14, ...
                          'BackgroundColor', button_bg_color, ...
                          'ForegroundColor', button_fg_color, ...
                          'Callback', @(src, ~) button_pressed(src, display));
            end
        end
    end

    % Button press handling
    function button_pressed(src, display)
        current_text = get(display, 'String');
        button_text = get(src, 'String');

        if strcmp(button_text, '=') % Evaluate the expression
            try
                % Prepare the expression
                expr = current_text;

                % Automatically insert parentheses if missing
                expr = regexprep(expr, '\bsin\s+([^\s]+)', 'sin($1)');
                expr = regexprep(expr, '\bcos\s+([^\s]+)', 'cos($1)');
                expr = regexprep(expr, '\btan\s+([^\s]+)', 'tan($1)');
                expr = regexprep(expr, '√\s*([^\s]+)', 'sqrt($1)');
                expr = regexprep(expr, '\bln\s+([^\s]+)', 'log($1)'); % Natural logarithm
                expr = regexprep(expr, '\blog\s+([^\s]+)', 'log10($1)'); % Base-10 logarithm
                expr = regexprep(expr, '\bEXP\s+([^\s]+)', 'exp($1)'); % Exponential function

                % Replace constants and operators
                expr = strrep(expr, 'π', 'pi'); % Replace π with pi
                expr = strrep(expr, '^', '.^'); % Replace ^ with element-wise power
                expr = strrep(expr, '!', 'factorial'); % Replace ! with factorial

                % Evaluate the final expression
                result = eval(expr);
                set(display, 'String', num2str(result));
            catch
                set(display, 'String', 'Error');
            end
        elseif strcmp(button_text, 'CE') % Clear display
            set(display, 'String', '0');
        elseif strcmp(button_text, '%') % Handle percentage
            try
                value = str2double(current_text);
                result = value / 100;
                set(display, 'String', num2str(result));
            catch
                set(display, 'String', 'Error');
            end
        elseif ismember(button_text, {'sin', 'cos', 'tan', 'ln', 'log', 'EXP', '√'}) % Handle functions
            % Append the function with an opening parenthesis
            if strcmp(current_text, '0') || strcmp(current_text, 'Error')
                set(display, 'String', [button_text '(']);
            else
                set(display, 'String', [current_text button_text '(']);
            end
        elseif strcmp(button_text, 'π') % Handle constant π
            if strcmp(current_text, '0') || strcmp(current_text, 'Error')
                set(display, 'String', 'π');
            else
                set(display, 'String', [current_text 'π']);
            end
        elseif strcmp(button_text, '!') % Handle factorial
            try
                value = str2double(current_text);
                result = factorial(value);
                set(display, 'String', num2str(result));
            catch
                set(display, 'String', 'Error');
            end
        else
            % Append the button text to the current text
            if strcmp(current_text, '0') || strcmp(current_text, 'Error')
                set(display, 'String', button_text);
            else
                set(display, 'String', [current_text button_text]);
            end
        end
    end
    uiwait(f)
end