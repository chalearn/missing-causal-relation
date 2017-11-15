function h=rec(Output, Target, sim_name, h, col)
%h=rec(Output, Target, sim_name, h, col)
% Plot regression error characteric curves, similar to the idea of Bi and
% Bennett (ICML 2003).

%Isabelle Guyon -- March 2013 -- isabelle@clopinet.com

if nargin<3 || isempty(sim_name), sim_name=''; end
if nargin<4 || isempty(h)
    h=figure;
else
    figure(h);
end
if nargin<5, col='b'; end
hold on

% Baseline model output
Boutput=ones(size(Output))*mean(Target);

% Score results
[MAE, MASE]=mae(Output, Target);
[BMAE, BMASE]=mae(Boutput, Target);

% Compute the prediction errors and baseline errors
E=abs(Output-Target);
Eb=abs(Boutput-Target);

% Sort the target values and then the errors in the same way
% The largest target values come first ("positive class")
[~, i]=sort(-Target);
Target=Target(i);
E=E(i);
Eb=Eb(i);

% Compute the cumulative errors
C=zeros(size(E));
C(1)=E(1);
for k=2:length(E)
    C(k)=C(k-1)+E(k);
end
C=C/length(E);

Cb=zeros(size(Eb));
Cb(1)=Eb(1);
for k=2:length(Eb)
    Cb(k)=Cb(k-1)+Eb(k);
end
Cb=Cb/length(Eb);

% Plot the resulting variables as a function of the target
plot(Target, C, col, 'LineWidth', 2);
plot(Target, Cb, 'k--', 'LineWidth', 2);
set(gca, 'Xdir', 'reverse');
xlabel('Target', 'FontSize', 14);
ylabel('Error Cumul / Sample size', 'FontSize', 14);

mini=min(Target);
maxi=max(Target);
plot([mini maxi], [MAE, MAE], 'k--');
plot([mini maxi], [BMAE, BMAE], 'k--');

xlim([mini, maxi]);
ylim([0, BMAE]);


title(sprintf('%s MAE=%5.2f MASE=%5.2f', sim_name, MAE, MASE), 'FontSize', 16, 'FontWeight', 'bold');

