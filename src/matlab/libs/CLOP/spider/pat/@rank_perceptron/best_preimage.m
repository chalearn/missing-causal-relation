function [r,ystar]=argmax(a,d,alpha,xsv,ysv,xstar,besty)
global curr;

%kerp='poly_lin_superfastpreimage'; deg=3;
kerp='rbf_lin_superfastpreimage'; sigma=5;
%kerp='joint_poly'; deg=3;
%kerp='joint_rbf'; sigma=0.5; 
%kerp='srbf_lin_superfastpreimage'; sigma=0.5;


if curr==Inf & strcmp(kerp,'poly_lin_superfastpreimage') 
   kerp='poly_lin_fastpreimage';    
end
if curr==Inf & strcmp(kerp,'rbf_lin_superfastpreimage') 
   kerp='rbf_lin_fastpreimage';    
end
if curr==Inf & strcmp(kerp,'srbf_lin_superfastpreimage') 
   kerp='srbf_lin_fastpreimage';    
end

%   34.1071   33.0875

% polys, 50 trn pts (knn=30.66)
% 2: 32.65
% 3: 29.81
% 4: 31.67
% sigmas:
% 10: 31.05
% 5:  29.08
% 1:  53.28
% jointpoly 
% 3: 33.09
% eps=1,2 doesn't seem to help either

%kerp='linear';
%calc(a.child,data());

xsv_index=xsv; ysv_index=ysv;
xsv=get_x(d,xsv);
ysv= a.dbase(ysv,:);
y=get_y(d);
a1=alpha;  

if strcmp(kerp,'joint_poly')
  x=repmat(xstar,get_dim(d),1);
  Ktt=(xsv(1:end,:)*x'); 
  Ktt2=(ysv(1:end,:)*(a.dbase)');     
  Kt=(((Ktt+Ktt2)/256)+1).^deg;
  Yest=((alpha'* Kt))';
  [val r]=max(Yest);  
  ystar=a.dbase(r,:);
end

if strcmp(kerp,'joint_rbf')
  x=repmat(xstar,get_dim(d),1);
  Kt=calc(kernel('srbf',sigma),data([ xsv ysv]),data([x a.dbase]))';
  Yest=((alpha'* Kt))';
  [val r]=max(Yest);  
  ystar=a.dbase(r,:);
end


if strcmp(kerp,'poly_sep')
  x=repmat(xstar,get_dim(d),1);
  Ktt=(((xsv(1:end,:)*x')/128)+1).^deg; 
  Ktt2=(((ysv(1:end,:)*(a.dbase)')/128)+1).^deg;     
  Kt=Ktt .* Ktt2;
  Yest=((alpha'* Kt))';
  [val r]=max(Yest);  
  ystar=a.dbase(r,:);
end

if strcmp(kerp,'poly_lin')
  x=repmat(xstar,get_dim(d),1);
  Ktt=(((xsv(1:end,:)*x')/128)+1).^deg; 
  Ktt2=(((ysv(1:end,:)*(a.dbase)')));     
  Kt=Ktt .* Ktt2;
 
  Yest=((alpha'* Kt))';
  [val r]=max(Yest);  
  ystar=a.dbase(r,:);
end


if strcmp(kerp,'poly_lin_fastpreimage')
  x=repmat(xstar,get_dim(d),1);
  Kt=(((xsv(1:end,:)*xstar')/128)+1).^deg; 
  ystar=sum( ysv .* repmat((a1 .* Kt),1,size(xsv,2)),1);
 dist=(sum((a.dbase-repmat(ystar,size(a.dbase,1),1)).^2,2));
 [val r]=min(dist); 
end


if strcmp(kerp,'poly_lin_superfastpreimage')
  global inikern; global YY; global svsz;  global oldalpha;
  if inikern==0
      inikern=1;
       YY=zeros(size(a.dbase,1),128);svsz=0;  oldalpha=[];
  end  
  oldalpha=[oldalpha ; zeros(1:length(alpha)-length(oldalpha))'];
  f=find(oldalpha~=alpha);
  if ~isempty(f) & length(alpha)>1
   for j=f'
    al=sign(alpha(j));
    Kt=(((xsv(j,:)*a.dtrain.X')/128)+1).^deg; 
    YY=YY+al*Kt'*ysv(j,:);
   end 
   svsz=length(alpha);oldalpha=alpha;
   end
   ystar=YY(curr,:);
% x2=repmat(xstar,get_dim(d),1);
%  Kt2=(((xsv(1:end,:)*xstar')/128)+1).^deg; 
%  ystar2=sum( ysv .* repmat((a1 .* Kt2),1,size(xsv,2)),1);
%if norm(ystar-ystar2)>1e-5
% keyboard
%end
dist=(sum((a.dbase-repmat(ystar,size(a.dbase,1),1)).^2,2));
[val r]=min(dist); 
end


if strcmp(kerp,'rbf_lin_superfastpreimage')
  global inikern; global KK; global YY; global svsz;  global oldalpha;
  if inikern==0
      inikern=1;
       YY=zeros(size(a.dbase,1),128);svsz=0;  oldalpha=[];
       KK=calc(kernel('rbf',sigma),data(a.dtrain.X)); 
  end  
  oldalpha=[oldalpha ; zeros(1:length(alpha)-length(oldalpha))'];
  f=find(oldalpha~=alpha);
  if ~isempty(f) & length(alpha)>1
   for j=f'
    al=sign(alpha(j));
    Kt=KK(xsv_index(j),:);
    YY=YY+al*Kt'*ysv(j,:);
   end 
   svsz=length(alpha);oldalpha=alpha;
   end
   ystar=YY(curr,:);
   dist=(sum((a.dbase-repmat(ystar,size(a.dbase,1),1)).^2,2));
    [val r]=min(dist); 
end




if strcmp(kerp,'rbf_lin_fastpreimage')
  x=repmat(xstar,get_dim(d),1);
  Kt=calc(kernel('rbf',sigma),data(xsv),data(xstar))'; 
  ystar=sum( ysv .* repmat((a1 .* Kt),1,size(xsv,2)),1);
 dist=(sum(([besty;a.dbase]-repmat(ystar,size(a.dbase,1)+1,1)).^2,2));
 r=sum(dist<dist(1));
end


if strcmp(kerp,'srbf_lin_superfastpreimage')
  global inikern; global KK; global YY; global svsz;  global oldalpha;
  if inikern==0
      inikern=1;
       YY=zeros(size(a.dbase,1),128);svsz=0;  oldalpha=[];
       KK=calc(kernel('srbf',sigma),data(a.dtrain.X)); 
  end  
  oldalpha=[oldalpha ; zeros(1:length(alpha)-length(oldalpha))'];
  f=find(oldalpha~=alpha);
  if ~isempty(f) & length(alpha)>1
   for j=f'
    al=sign(alpha(j));
    Kt=KK(xsv_index(j),:);
    YY=YY+al*Kt'*ysv(j,:);
   end 
   svsz=length(alpha);oldalpha=alpha;
   end
   ystar=YY(curr,:);
   dist=(sum((a.dbase-repmat(ystar,size(a.dbase,1),1)).^2,2));
    [val r]=min(dist); 
end

if strcmp(kerp,'srbf_lin_fastpreimage')
  x=repmat(xstar,get_dim(d),1);
  Kt=calc(kernel('srbf',sigma),data(xsv),data(xstar))'; 
  ystar=sum( ysv .* repmat((a1 .* Kt),1,size(xsv,2)),1);
 dist=(sum((a.dbase-repmat(ystar,size(a.dbase,1),1)).^2,2));
 [val r]=min(dist); 
end



if strcmp(kerp,'linear')  % linear method
 y=sum( ysv .* repmat(a1 .* (xsv*xstar'),1,size(xsv,2)),1);
 y2=sum(ysv .* xsv .* repmat(a1,1,size(xsv,2)) .* repmat(xstar,size(xsv,1),1) ,1);
 ystar=(1-a.gamma)*y+(a.gamma)*y2;
 ystar=(1-a.id_w)*ystar+ (a.id_w)*xstar;
 % find closest preimage
 dist=(sum((a.dbase-repmat(ystar,size(a.dbase,1),1)).^2,2));
 [val r]=min(dist); 
end

