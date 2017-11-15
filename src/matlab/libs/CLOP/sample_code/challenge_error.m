function E=challenge_error(guessed_ber, test_ber, score_type, sigma, epsilon)
%E=challenge_error(guessed_ber, test_ber, score_type, sigma, epsilon)
% Compute criteria according to which the participants may be ranked.
% Inputs:
% guessed_ber -- Guessed balanced error rate using training data only.
% test_ber    -- Actual test BER.
%                delta_ber=abs(guessed_ber - test_ber);
% score_type  -- 1: delta_ber -- this is the default.
%             -- 2: test_ber + delta_ber
%             -- 3: test_ber + delta_ber * (1- exp(-delta_ber/sigma)
%             -- 4: test_ber + abs(delta_ber-epsilon) 
%             -- 5: test_ber + abs(delta_ber-epsilon) * (1- exp(-delta_ber/sigma)
% sigma       -- Actual error bar on the test_ber -- default 0.
% epsilon     -- Guessed error bar on guessed_ber.
% Note: If score_type=1 would be used, the best ranking participants according
% to test_ber would be first pre-selected.

% Isabelle Guyon -- January 2005 -- isabelle@clopinet.com

if nargin<3, score_type=1; end
if nargin<4 | isempty(sigma), sigma=0; end
if nargin<5, epsilon=0; end
if sigma==0 & score_type==3, score_type=2; end

delta_ber=abs(guessed_ber - test_ber);
delta_delta_ber=abs(delta_ber-epsilon);
switch score_type
    case 1, E=delta_ber;
    case 2, E=test_ber + delta_ber;
    case 3, E=test_ber + delta_ber .* (1- exp(-delta_ber/sigma));
    case 4, E=test_ber + delta_delta_ber;
    case 5, E=test_ber + delta_delta_ber .* (1- exp(-delta_delta_ber/sigma));
end

