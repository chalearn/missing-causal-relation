function a = joint_kernel(kType,param)   

%===========================================================================
% Joint kernel object - for calculating inner products in joint feature spaces
%===========================================================================
% Attributes: 
%  ker='tensor'      -- type of kernel (tensor, SEE BELOW)
%  kerparam=[]       -- parameters of the kernel  
%  calc_on_output=0  -- calc kernel on outputs (Ys), rather than inputs (Xs)
%  output_distance=0 -- output associated distance rather than kernel
%  dat=[]            -- storage of data (for use when training/testing kernels)
%  calc_on=[]   -- indices of input components to calculate the joint kernel on.
%                           If calc_on=[] the joint kernel is calculated on
%                           all input spaces.
% 
%
% Methods:
%  calc(k,d1,[d2]):     calc inner products in feature space between data d1 
%                       and d2 (or itself if d2 not specified) using joint kernel k 
%  get_norm(k,d):       calc norm of data in feature space
%  train,test
%   
% KERNEL               PARAMETERS &  DESCRIPTION
%  tensor                             k([x1,y2],[x1,y2])=(x1.x2)*(y1.y2)
%
%
%

a.calc_on_output=0;   %% work as an input kernel as default
a.calc_on= []; %% indices of input spaces to calc on

a.output_distance=0;
a.callback=[];

a.kercaching = 0;
if nargin==0
    % If there is no args, linear is the default kernel 
    a.ker='tensor'; 
    a.kerparam=[];
else
    if nargin==1,
        % if there is only one parameter, it may be because
        % this is a cell...
        if iscell(kType),
            a.ker = kType{1};
            for i=2:length(kType),
                a.kerparam{i-1}=kType{i};
            end
        else
            % ...or a custom kernel!
            a.ker=kType;
            a.kerparam=[];
        end
    else
        % There is more than one arg
        a.ker = kType;
        a.kerparam = param;
    end
end

a.dat=[];
algo=algorithm('joint_kernel');
a= class(a,'joint_kernel',algo);




