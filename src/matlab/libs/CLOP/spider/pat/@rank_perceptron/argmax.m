function [r,ystar]=argmax(a,d,alpha,xsv,ysv,xstar)
global curr; % stores the index of current example in training.m

kerp='linear';

if strcmp(a.kertype,'poly')
    kerp='poly_lin_superfastpreimage'; deg=a.kerparam;   
end
if strcmp(a.kertype,'rbf')
    kerp='rbf_lin_superfastpreimage'; sigma=a.kerparam;   
end

%% if in test mode, cannot use fast caching to generate pre-images
if curr==Inf & strcmp(kerp,'poly_lin_superfastpreimage') 
    kerp='poly_lin_fastpreimage';    
end
if curr==Inf & strcmp(kerp,'rbf_lin_superfastpreimage') 
    kerp='rbf_lin_fastpreimage';    
end

xsv_index=xsv; ysv_index=ysv; % index into training set
xsv=get_x(d,xsv);
ysv= a.dbase(ysv,:); % ???
y=get_y(d); % get index into dbase from d.Y
a1=alpha;  

if iscell(a.exdbase) & curr~=Inf % if preimage set different for each example 
    mydbase=a.dbase(a.exdbase{curr},:);% and still in training mode (curr==index of train pt)
end
if ~isempty(a.exdbase) & ~iscell(a.exdbase) & curr==Inf % if preimage set different for each example 
    mydbase=a.exdbase; % in test mode we select possible preimages from a.exdbase 
else
    mydbase=a.dbase;          % unless all data uses universal database set
 end

if strcmp(kerp,'poly_lin')
  x=repmat(xstar,get_dim(d),1);
  Ktt=(xsv(1:end,:)*x'+1).^deg; 
  Ktt2=(((ysv(1:end,:)*(a.dbase)')));     
  Kt=Ktt .* Ktt2;
 
  Yest=((alpha'* Kt))';
  [val r]=max(Yest);  
  ystar=a.dbase(r,:);
end

if strcmp(kerp,'poly_lin_fastpreimage')
  x=repmat(xstar,get_dim(d),1);
  Kt=(xsv(1:end,:)*xstar'+1).^deg; 
  ystar=sum((ysv'*repmat((a1 .* Kt),1,size(xsv,2)))',1);
 dist=(sum((mydbase-repmat(ystar,size(mydbase,1),1)).^2,2));
 [val r]=min(dist); 
end



if strcmp(kerp,'poly_lin_superfastpreimage')
  global inikern; global KK; global YY; global svsz;  global oldalpha;
  if inikern==0
      inikern=1;
       YY=zeros(size(d.X,1),size(a.dbase,2));svsz=0;  oldalpha=[];
       KK=calc(kernel('poly',deg),data(a.dtrain.X)); 
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
   dist=(sum((mydbase-repmat(ystar,size(mydbase,1),1)).^2,2));
    [val r]=min(dist); 
end

if strcmp(kerp,'rbf_lin_superfastpreimage')
  global inikern; global KK; global YY; global svsz;  global oldalpha;
  if inikern==0
      inikern=1;
       YY=zeros(size(d.X,1),size(a.dbase,2));svsz=0;  oldalpha=[];
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
   dist=(sum((mydbase-repmat(ystar,size(mydbase,1),1)).^2,2));
  [val r]=min(dist); 
end


if strcmp(kerp,'rbf_lin_fastpreimage')
  x=repmat(xstar,get_dim(d),1);
  Kt=calc(kernel('rbf',sigma),data(xsv),data(xstar))'; 
  ystar=sum((ysv'*repmat((a1 .* Kt),1,size(xsv,2)))',1);
 dist=(sum((mydbase-repmat(ystar,size(mydbase,1),1)).^2,2));
 [val r]=min(dist); 
 end

if strcmp(kerp,'linear')  % linear method
 ystar=sum( ysv .* repmat(a1 .* (xsv*xstar'),1,size(ysv,2)),1);
 % find closest preimage
 dist=(sum((mydbase-repmat(ystar,size(mydbase,1),1)).^2,2));
 [val r]=min(dist); 
end

dist