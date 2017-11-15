function simple_score(resudir, truthdir, scoredir, featsel)
%simple_score(resudir, truthdir, scoredir, featsel)
% Function to score the results of the benchmark, without sorting them
% resudir -- where the results are (.resu, .conf files)
% truthdir -- where the truth labels are
% scoredir -- where to store the scores
% featsel -- 0/1 flag indicating whether we perform feature selection and
%         -- return .feat files.

% Isabelle Guyon -- September 2003 -- isabelle@clopinet.com

% DISCLAIMER: ALL INFORMATION, SOFTWARE, DOCUMENTATION, AND DATA ARE PROVIDED "AS-IS" 
% THE ORGANIZERS DISCLAIMS ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
% IN NO EVENT SHALL ISABELLE GUYON AND/OR OTHER BENCHMARK ORGANIZERS BE LIABLE FOR ANY SPECIAL, 
% INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER ARISING OUT OF OR IN CONNECTION 
% WITH THE USE OR PERFORMANCE OF BENCHMARK SOFTWARE, DOCUMENTS, MATERIALS, PUBLICATIONS, OR 
% INFORMATION MADE AVAILABLE. 

if nargin<3
    warning off
    status=mkdir(scoredir);
    warning on
end
if nargin<4
    featsel=0;
end
fout=fopen([scoredir '/Simple-' date '.score'],'w') ;

% Identify the method, dataset, and result types:
[methodir, dataset, method] = identify(resudir, 0);

for i=1:length(dataset)
    if ~fcheck([truthdir '/' upper(dataset{i}) '/' dataset{i} '_test.labels']);
        resuset={'train'; 'valid'}; 
    else
        resuset={'train'; 'valid'; 'test'};
    end
end

if featsel
    resuset=['feat'; resuset];
end

Nd=length(dataset);
Nm=length(methodir);

fprintf('Found %d datasets and %d methods\n', Nd, Nm);

% Loop over datasets and methods:
for i=1:Nd
    if featsel
        fprintf(fout, '\n** %s ** \nmethod\tfrac_feat\tfrac_probe\t', upper(dataset{i}));
        beg=2;
    else
        fprintf(fout, '\n** %s ** \nmethod\t', upper(dataset{i}));
        beg=1;
    end
    for k=beg:length(resuset)
        fprintf(fout, '%s_ber\t', resuset{k});
    end
    for k=beg:length(resuset)
        fprintf(fout, '%s_auc\t', resuset{k});
    end
    fprintf(fout, '\n');
    for j=1:length(methodir)
        errate=-1*ones(length(resuset),1);
        aucval=-1*ones(length(resuset),1);
        frac_feat=-1;
        for k=1:length(resuset)
            % Get the truth values (note: the 'feat' also have truth values)
            Y=fload([truthdir '/' upper(dataset{i}) '/' dataset{i} '_' resuset{k} '.labels']);
            % Get the results
            Y_resu=[];
            F_resu=[];
            Y_conf=[];
            Y_score=[];
            F_pval=[];
            F_score=[];
            if ~strcmp(resuset{k}, 'feat')
                % Get the outputs
                Y_resu=fload([resudir '/' methodir{j} '/' dataset{i} '_' resuset{k} '.resu']);
                Y_conf=fload([resudir '/' methodir{j} '/' dataset{i} '_' resuset{k} '.conf']);
                if ~isempty(Y_conf) Y_score=Y_conf.*Y_resu; end
            else
                F_resu=fload([resudir '/' methodir{j} '/' dataset{i} '.feat']);
                if isempty(F_resu), F_resu=1:length(Y); end % Assume all the features have been used
            end
            % Compute the performance
            if ~isempty(Y_resu) & ~isempty(Y)
                errate(k)=balanced_errate(Y_resu, Y);
                if ~isempty(Y_score)
                    aucval(k) = auc(Y_score, Y);
                end
            elseif ~isempty(F_resu) & ~isempty(Y)
                probe_num=length(find(Y(F_resu)==-1));
                all_feat_num=length(Y);
                used_feat_num=length(F_resu);
                errate(k)=probe_num/used_feat_num;
                frac_feat=used_feat_num/all_feat_num;
            end
        end % for k
        mydate='';%get_date([resudir methodir{j} '\date']);
        if featsel
            frac_probe=errate(1);
            errate=errate(2:length(errate));
            aucval=aucval(2:length(aucval));
        end
        if any(find(errate~=-1))
            if featsel
            	fprintf(fout, '%s\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f', method{j}, 100*frac_feat, 100*frac_probe, 100*errate, 100*aucval);
            else
                fprintf(fout, '%s\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f', method{j}, 100*errate, 100*aucval);
            end
            fprintf(fout, '\n');
            %fprintf(fout, '%s\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%g\n', method{j}, 100*frac_feat, 100*frac_probe, 100*errate, 100*aucval,mydate);
        end % Add \t%5.2f\t%5.2f\t%5.2f\t%5.2f for sanity check
    end % for j
end % for i

fclose(fout);

        
    
