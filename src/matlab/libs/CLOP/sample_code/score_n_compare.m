function score_n_compare(resudir, truthdir, scoredir, featsel)
%score_n_compare(resudir, truthdir, scoredir, featsel)
% Function to score the *test* results of the challenge
% and compute statistically significant differences
% in the ranked list.

% Isabelle Guyon -- September 2005 -- isabelle@clopinet.com

% DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA ARE PROVIDED "AS-IS" 
% ISABELLE GUYON AND/OR OTHER ORGANIZERS DISCLAIM ANY EXPRESSED OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
% FOR ANY PARTICULAR PURPOSE, AND THE WARRANTY OF NON-INFRIGEMENT OF ANY THIRD PARTY'S 
% INTELLECTUAL PROPERTY RIGHTS. IN NO EVENT SHALL ISABELLE GUYON AND/OR OTHER ORGANIZERS 
% BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
% ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF SOFTWARE, DOCUMENTS, 
% MATERIALS, PUBLICATIONS, OR INFORMATION MADE AVAILABLE FOR THE CHALLENGE. 

if nargin<3
    warning off
    status=mkdir(scoredir);
    warning on
end
if nargin<4
    featsel=0;
end
verbose=1;                                % Change to 1 to see the missing files
nosort=0;                                 % print unsorted results
makedir(scoredir);
fout=fopen([scoredir '/Compar-' date '.score'],'w') ;

% Identify the method, dataset, and result types:
[methodir, dataset, method] = identify(resudir, 1);
Nd=length(dataset);
Nm=length(method);

set_names={'train', 'valid', 'test'};
rank=[]; % rank of the various methods for the various datasets (datasets in lines)

% Loop over datasets and methods:
for i=1:Nd
    fprintf('\n** %s **\n', upper(dataset{i}));
    fprintf(fout, '\n** %s **\n', upper(dataset{i}));
    
    for k=1:length(set_names)
        % Read the target values:
        Y=fload([truthdir '/' upper(dataset{i}) '/' dataset{i} '_' set_names{k} '.labels']);
        patnum=length(Y);

        % Read the results:
        Y_resu=cell(Nm, 1); % Predicted value of the classifier (binary).
        Y_score=cell(Nm, 1); % Discriminant coefficient.
        ber_guess=zeros(Nm, 1); % Guessed ber values.
        for j=1:Nm
            fn=[resudir '/' methodir{j} '/' dataset{i} '_' set_names{k} '.resu'];
            Y_resu{j}=fload(fn); 
            fn=[resudir '/' methodir{j} '/' dataset{i} '_' set_names{k} '.conf'];
            Y_conf=fload(fn);
            fn=[resudir '/' methodir{j} '/' dataset{i} '.guess'];
            berg=fload(fn);
            if ~isempty(Y_conf), 
                Y_score{j}=Y_conf.*Y_resu{j}; 
            else
                Y_score{j}=Y_resu{j}; % This was added to be able to get an AUC for everyone
            end
            if isempty(berg) | berg<0 | berg>1, 
                ber_guess(j)=1; 
            else
                ber_guess(j)=berg;
            end
        end

        % Compute simple statistics:
        [Eff_method{k}, Berrate{k}, Sigma{k}, Aucval{k}, Guess_error{k}, Challenge_score{k}, Y_resu, Y_score] = ...
            compu_stats(method, Y_resu, Y_score, Y, ber_guess);
    end % Loop over sets
    
    eff_method=Eff_method{3};
    
    
    train_berrate=Berrate{1};
    train_sigma=Sigma{1};
    train_auc=Aucval{1};
    train_error=Guess_error{1}; 
    train_score=Challenge_score{1};
    
    valid_berrate=Berrate{2};
    valid_sigma=Sigma{2};
    valid_auc=Aucval{2};
    valid_error=Guess_error{2}; 
    valid_score=Challenge_score{2};
    
    test_berrate=Berrate{3};
    test_sigma=Sigma{3};
    test_auc=Aucval{3};
    test_error=Guess_error{3}; 
    test_score=Challenge_score{3};
    
    Nem=length(eff_method);  
    if verbose | nosort
        fprintf(fout, '\nUnsorted results:\nmethod\tguess\ttrain\ttrain\ttrain\ttrain\ttrain\tvalid\tvalid\tvalid\tvalid\tvalid\ttest\ttest\ttest\ttest\ttest\n');
        fprintf(fout, '\t\tBER\tAUC\tSigma\tDelta\tScore\tBER\tAUC\tSigma\tDelta\tScore\tBER\tAUC\tSigma\tDelta\tScore\n');
        for j=1:Nem
            if train_auc(j)>0
                fprintf(fout, '%s\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\n', ...
                eff_method{j}, rp(ber_guess(j)), ...
                rp(train_berrate(j)), rp(train_auc(j)), rp(train_sigma(j)), rp(train_error(j)), rp(train_score(j)), ...
                rp(valid_berrate(j)), rp(valid_auc(j)), rp(valid_sigma(j)), rp(valid_error(j)), rp(valid_score(j)), ...
                rp(test_berrate(j)), rp(test_auc(j)), rp(test_sigma(j)), rp(test_error(j)), rp(test_score(j)));
            end
        end
    end

    if ~nosort
        % Sort the entries according to score
        [cs, si]=sort(test_score); % Sort in ascending order of score.

        [es, ei]=sort(test_berrate); % Sort in ascending order of ber.
        er=zeros(size(ei));
        er(ei)=1:length(ei); % Rank according to e
        [as, ai]=sort(-test_auc); % Sort in descending order of AUC.
        ar=zeros(size(ai));
        ar(ai)=1:length(ai); % Rank according to a

        fprintf(fout, '\nSorted results:\nmethod\ttestAUC (rank)\ttestBER (rank)\tsigmaBER\tguessBER\tdeltaBER\tscore\n');
        for j=1:Nem
            if train_auc(si(j))>0
            fprintf(fout, '%s\t%5.2f (%d)\t%5.2f (%d)\t%5.4f\t%5.4f\t%5.4f\t%5.4f\n', ...
                eff_method{si(j)}, ...
                rp(test_auc(si(j))), ar(si(j)), rp(test_berrate(si(j))), er(si(j)), rp(test_sigma(si(j))) ,  ...
                rp(ber_guess(si(j))), rp(test_error(si(j))), rp(test_score(si(j))));
            end 
        end
        rank(i, si')=1:length(si);
    end % nosort
end % The end!

if ~nosort
    % Global ranking
    %%%%%%%%%%%%%%%%
    % Only if all methods are the same for all data sets:
    challenge_score=mean(rank);
    [cs, si]=sort(challenge_score);
    fprintf('\n** GLOBAL **\n');
    fprintf(fout, '\n** GLOBAL **\n');
    for j=1:Nem
        if train_auc(si(j))>0
        fprintf(fout, '%s\t%5.2f\n', ...
            eff_method{si(j)}, challenge_score(si(j)));
        end 
    end
end

fclose(fout);