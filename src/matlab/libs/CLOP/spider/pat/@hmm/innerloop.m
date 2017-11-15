function [Tnew,p0new,Hnew,ll] = bwx(alg,Y,T,p0,H,updateflags)

%[Tnew,p0new,Hnew,ll] = bwx(Y,T,p0,H,updateflags)
%
% do one iteration of BaumWelch to update HMM params
% for DISCRETE SYMBOL HMMs
% calls fbx.m to do forward-backward (E-step)
%
% Y is a vector (or cell array of vectors if many sequences) of integers
%
% T(i,j) is the probability of going to j next if you are now in i
% p0(j)  is the probability of starting in state j
% H(m,j) is the probability of emitting symbol m if you are in state j
%
% updateflags controls the update of parameters
%   it is a three-vector whose elements control the updating of
%   [T,p0,H] -- nonzero elements mean update that parameter
%
% ll is a scalar (or vector for multiple sequences) that holds 
%    the log likelihood per symbol (ie total divided by seq length)
%

if(nargin<6) updateflags=[1,1,1]; end
assert(alg,length(updateflags==3));

if(updateflags(1)) Tnew  = zeros(size(T));   else Tnew =T;   end  
if(updateflags(2)) p0new = zeros(size(p0));  else p0new=p0; end
if(updateflags(3)) Hnew  = zeros(size(H));   else Hnew =H;   end

ll=[];
if(~iscell(Y)) Ytmp=cell(1,1); Ytmp{1}=Y; Y=Ytmp; clear Ytmp; end

if(any(updateflags))  
  [M,kk] = size(H);
  ll=zeros(size(Y));
  gammasum=zeros(1,kk);
  for seqs=1:length(Y)    
    tau = length(Y{seqs});
    [gamma,eta,rho] = Estep(alg,Y{seqs},T,p0,H,updateflags);
    if(updateflags(1)) Tnew  = Tnew  + eta;         end
    if(updateflags(2)) p0new = p0new + gamma(:,1);  end
    if(updateflags(3))
      gammasum = gammasum + sum(gamma,2)';
      for qq=1:M
        ff = find(Y{seqs}==qq);
        Hnew(qq,:) = Hnew(qq,:) + sum(gamma(:,ff),2)';
      end
    end
    ll(seqs)=sum(log(rho))/tau;
  end
  % normalize probability distributions
  if(updateflags(1)) Tnew  = Tnew./(sum(Tnew,2)*ones(1,kk)); end
  if(updateflags(2)) p0new = p0new/sum(p0new);               end
  if(updateflags(3)) Hnew  = Hnew./(ones(M,1)*gammasum);     end  
end

