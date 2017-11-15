function h=regshow(Output, Target, sim_name, h, col, leg, unit)
%h=regshow(Output, Target, sim_name, h, col, leg, unit)
% Output: result of regression (dim N)
% Target: target values (dim N)
% sim_name: simulation name
% h: figure handle
% col: dim N vector of indices of the studies (colors of markers between 1 and C)
% leg: legend entries (cell array of C strings: studies)
% unit: a string indicating the units of Ouput and Target


%Isabelle Guyon -- April 2013 -- isabelle@clopinet.com

show_mase=0;

base=0;
if nargin<3 || isempty(sim_name), sim_name=''; end
if nargin<4 || isempty(h)
    h=figure;
else
    figure(h);
end
if nargin<5, 
    base=1; 
    col='b.'; 
end
if nargin<6,
    leg={};
end
if nargin<7,
    unit='';
end

multicolor=0;
colvec=[];
if isnumeric(col)
    multicolor=1;
    colvec=col;
    col='rgbkmcy';
    base=1;
end
hold on

% Score results
if show_mase
    [~, MASE]=mae(Output, Target);
end
[~, R2]=mse(Output, Target);

% Show legend
if ~isempty(leg)
    for k=1:length(leg)
        plot(0, 0, [col(k) '.'], 'MarkerSize', 20);
    end
    legend(leg, 'Location', 'SouthEast');
    plot(0, 0, 'o', 'MarkerFaceColor', [1 1 1], 'MarkerEdgeColor', [1 1 1], 'MarkerSize', 20);
end

% Plot Output as func Target
if multicolor
    hold on
    for k=1:length(Target)
        plot(Target(k), Output(k), [col(colvec(k)), 'o'], 'MarkerFaceColor', col(colvec(k)), 'LineWidth', 2);
    end
else
    plot(Target, Output, col, 'LineWidth', 2);
end
xlabel(['Target [' unit ']'], 'FontSize', 14);
ylabel(['Output [' unit ']'], 'FontSize', 14);

xmin=min(Target);
ymin=min(Output);

xmax=max(Target);
ymax=max(Output);

if base
    plot([xmin xmax], [xmin xmax], 'k--');
end
%xlim([xmin, xmax]);
%ylim([ymin, ymax]);
if show_mase
    title(sprintf('%s R2=%5.2f MASE=%5.2f', sim_name, R2, MASE), 'FontSize', 16, 'FontWeight', 'bold');
else
    title(sprintf('%s R2=%5.2f', sim_name, R2), 'FontSize', 16, 'FontWeight', 'bold');
end
