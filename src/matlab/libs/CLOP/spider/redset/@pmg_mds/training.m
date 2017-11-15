function [d, a] =  training(a,d)
  


if a.algorithm.verbosity>0
  disp(['calculating pre-image for each coordinate specified in data with ', get_name(a.child)])
end

if(a.kp.algorithm.trained==0)
	disp('train me first, or give kpca which is trained');
    return;
end

if(~isempty( a.dn) )
	a.dn=a.kp.dat;	
end


if( ~isempty(a.rn))
	a.rn=test(a.kp,a.dat);	
end
  
d=test(a,d);
