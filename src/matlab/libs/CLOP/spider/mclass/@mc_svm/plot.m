function plot(a,granul)
  
d=a.Xsv;
x=d.X;
y=d.Y;
ax1=min(x); ax2=max(x);

granul=100;
minX=floor(ax1(1));
maxX=ceil(ax2(1));
minY=floor(ax1(2));
maxY=ceil(ax2(2));
axis_sz=[minX maxX minY maxY];
minX=minX-2; maxX=maxX+2; minY=minY-2; maxY=maxY+2;
gridx=[]; gridy=[];

mx=zeros(granul*granul,2);
for i=1:granul
 for j=1:granul
   mx((i-1)*granul+j,:)= [minX+(i-1)*(maxX-minX)/granul minY+(j-1)*(maxY-minY)/granul ] ;
   gridx(i)=minX+(i-1)*(maxX-minX)/granul;
   gridy(j)=minY+(j-1)*(maxY-minY)/granul;
end
end


temp=zeros(granul,granul);

sflag=a.algorithm.use_signed_output;
a.algorithm.use_signed_output=0;

 kTemp=get_kernel(a.child,data(mx),a.Xsv);
 [resX,yTemp]=max(((a.alpha'* kTemp)+a.b0*ones(1,size(kTemp,2))),[],1);
 
resX=yTemp;
for i=1:granul
 for j=1:granul
  temp(i,j)= resX( (i-1)*granul+j);
  end
end
hold on;

FeatureLines = [0 -2000 2000]';  %cheap hack to only get the decision boundary
pcolor(gridx, gridy, temp') ;
[c,h] = contour(gridx, gridy, 20*temp', 'Color',[1,0,0]) ;
colormap('bone')

if(length(h)>1)
    set(h(1),'LineWidth',2);
end
i=1;
while length(h)>i
 set(h(i+1),'LineWidth',2);
   i = i+1;
end
FeatureLines=[-1 1]' ;  % now the SV lines
[c,h] = contour(gridx, gridy, temp', FeatureLines,'c:') ;
if ~isempty(h)
set(h(1),'LineWidth',2,'LineStyle',':');
 i=1;
 while length(h)>i
   set(h(i+1),'LineWidth',2,'LineStyle',':');
   i = i+1;
end
end
shading interp



[n,mdim]=size(y);

Z=[];
for i=1:mdim

    sv=find(abs(a.alpha(:,i))>1e-4);
    I=find(y(:,i)==1);
    c=rand(3,1);
    plot(x(I,1),x(I,2),'.','Color',c);
    I=find(y(sv,i)==1);
    plot(x(sv(I),1),x(sv(I),2),'o','Color',c);
end



axis(axis_sz);

