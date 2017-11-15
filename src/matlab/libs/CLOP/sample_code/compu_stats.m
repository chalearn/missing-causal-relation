function [eff_method, berrate, sigma, aucval, guess_error, challenge_score, Y_resu, Y_score] = compu_stats(method, Y_resu, Y_score, Y, ber_guess)
%[eff_method, berrate, sigma, aucval, guess_error, challenge_score, Y_resu, Y_score] = ...
% compu_stats(method, Y_resu, Y_score, Y, ber_guess)
% Compute data statistics.
% Inputs:
% method    --  A cell array of strings with method names.
% Y_resu    --  A cell array with, for each method, the result vector of +1 predictions.
% Y_score   --  A cell array with, for each method, the score vector.
% Y         --  The target value vector.
% bear_guess --  A vector with, for each method, the predicted BER.
% Returns:
% eff_method -- The methods actually having results (cell array of strings).
% berrate    --  A vector of dim length(eff_method) with the balanced error rates.
% sigma     --  A vector of dim length(eff_method) with the error bar on the ber.
% aucval    --  A vector of dim length(eff_method) with the area under the curves.
% guess_error --  A vector of dim length(eff_method) with the error made on the guess.
% challenge_score -- The score used to rank the participants.
% Also returns the input arrays Y_resu, Y_score, re-dimensioned to eff_method.

% Isabelle Guyon    -- September 2005 -- isabelle@clopinet.com

Nm=length(method);
berrate=-1*ones(Nm,1); % Balanced error rate.
sigma=-1*ones(Nm,1); % Error bars on the ber.
aucval=-1*ones(Nm,1); % Area under the curve for the classification.
guess_error=-1*ones(Nm,1); % Errors made on the guess.
challenge_score=-1*ones(Nm,1); % Challenge score.

for j=1:Nm
    % Balanced error rate, error bar, and guess error:
    if all(size(Y_resu{j})==size(Y))
        [berrate(j),e1,e2,sigma(j)]=balanced_errate(Y_resu{j}, Y);
        guess_error(j)=challenge_error(ber_guess(j), berrate(j));
        challenge_score(j)=challenge_error(ber_guess(j), berrate(j),3,sigma(j));
    end
    % AUC:
    if all(size(Y_score{j})==size(Y))
        aucval(j) = auc(Y_score{j}, Y);
    end
    % 
end

% Restrict the method set to those having effectively results:
%eff_idx=find(berrate~=-1);
eff_idx=1:length(berrate);
eff_method=method(eff_idx);
Y_resu=Y_resu(eff_idx);
Y_score=Y_score(eff_idx);
berrate=berrate(eff_idx);
aucval=aucval(eff_idx);
sigma=sigma(eff_idx);
guess_error=guess_error(eff_idx);
challenge_score=challenge_score(eff_idx);    