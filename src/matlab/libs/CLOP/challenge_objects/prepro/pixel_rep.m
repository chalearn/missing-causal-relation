function D = pixel_rep(D, input_name)
%D = pixel_rep(D, input_name)
% D: data structure
% input_name: where the data is
% Converts gisette data to a pixels representation
% Note: just playing with feat_idx does not work because some pixels
% that are constantly zero have been omitted in the original
% representation.

% Isabelle Guyon -- October 2005 -- isabelle@clopinet.com

F=textread([input_name '_feat.info'], '%s\n');

kk=0;
for k=1:length(F)
    ff=F{k};
    if isempty(strfind(ff, 'perm'))&isempty(strfind(ff, 'probe'))&isempty(strfind(ff, 'pair'))
        kk=kk+1;
        dash=strfind(ff, '-');
        ff=ff(dash(end)+1:end);
        feat_idx(kk)=str2num(ff);
        feat_loc(kk)=k;
    end
end

setnames=fields(D);
for k=1:length(setnames)
    M=zeros(get_dim(D.(setnames{k})),28*28);
    M(:,feat_idx)=D.(setnames{k}).X(:,feat_loc);
    D.(setnames{k}).X=M;
end