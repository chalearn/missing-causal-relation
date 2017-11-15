function data_square_plot(algo,area,granul,dat)
%
% Plots a surface plot of an svm which uses !_2_! dimensional inputs.
% Red decision line is drawn.
%
% Usage :  
%           plot(a,[ xMin xMax yMin yMax],step);
%
% Arguments 
%    area -  specifies the area which shall be plotted
%
% optional argument (with defaults)
%     s=50    -  determines the granularity of the area to be plotted
%                ATTENTION: low numbers introduce artefacts.
%
% The colormap can be changed afterwards.
%
% Note:
%   -1000 on the colorbar denotes the decision line.
%
% Example :  
%   d=gen(spiral({'n=1','m=50'}));
%   [r s0]=train(svm(kernel('rbf',1)),d)
%   plot(s0,[ -20 20 -20 20]);

if(nargin==2)
    granul=100;
end
if(isempty(granul))
    granul=100;
end    
clf;

minX=area(1);
max_x=area(2);
minY=area(3);
maxY=area(4);

mx=zeros(granul*granul,2);
for i=1:granul-1
 for j=1:granul-1
   mx((i-1)*granul+j,:)= [minX+(i-1)*(max_x-minX)/granul minY+(j-1)*(maxY-minY)/granul ] ;
  end
end


temp=zeros(granul,granul);

sflag=algo.algorithm.use_signed_output;
algo.algorithm.use_signed_output=0;

resX=test(algo,data(mx));
resX=sign(get_x(resX)).*sqrt(abs(get_x(resX)));


for i=1:granul
 for j=1:granul
  temp(i,j)= resX( (i-1)*granul+j);
  end
end
hold on;
surf(1:granul,1:granul,temp'-1000);
view(2);
shading interp; 

%[c,h]=contour(1:granul,1:granul,temp',[0 0],'r');
%   clabel(c,h);
colorbar

if( exist('dat'))
    for i=1:length(dat.X(:,1))
        if dat.Y(i,1) > 0
            plot3( granul+granul*(minX+dat.X(i,1))/(max_x-minX) ,granul+granul*(minY+dat.X(i,2))/(maxY-minY),-100,'resX');
        else
            plot3( granul+granul*(minX+dat.X(i,1))/(max_x-minX) ,granul+granul*(minY+dat.X(i,2))/(maxY-minY),-100,'go');
        end
    end
end

a0.algorithm.use_signed_output=sflag;

colormap gray;

hold off;