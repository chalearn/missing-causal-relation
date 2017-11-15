function ld_plot(X,Y,w,b,active_set,Xtest,Ytest)
%Linear Discriminant Plotting routine
%
%  Usage: ld_plot(X,Y,w,b,active_set,Xtest,Ytest)
%
%  Parameters: X      - Training inputs
%              Y      - Training targets
%              w,b    - weight and bias
%
%  Author: Steve Gunn (srg@ecs.soton.ac.uk)
%  Adapted by Isabelle Guyon

if nargin<6, Xtest=[]; end
if nargin<7, Ytest=[]; end
if nargin<5, active_set=length(Y); end
if (nargin < 3 ) % check correct number of arguments
    help ld_plot;
    return
end

yaxis = 2;
xaxis = 1;
mag = 0.1;
aspect = 0;
    
    % Scale the axes
    xmin = min(X(:,xaxis));, xmax = max(X(:,xaxis)); 
    ymin = min(X(:,yaxis));, ymax = max(X(:,yaxis)); 
    xa = (xmax - xmin);, ya = (ymax - ymin);
    if (~aspect)
       if (0.75*abs(xa) < abs(ya)) 
          offadd = 0.5*(ya*4/3 - xa);, 
          xmin = xmin - offadd - mag*0.5*ya;, xmax = xmax + offadd + mag*0.5*ya;
          ymin = ymin - mag*0.5*ya;, ymax = ymax + mag*0.5*ya;
       else
          offadd = 0.5*(xa*3/4 - ya);, 
          xmin = xmin - mag*0.5*xa;, xmax = xmax + mag*0.5*xa;
          ymin = ymin - offadd - mag*0.5*xa;, ymax = ymax + offadd + mag*0.5*xa;
       end
    else
       xmin = xmin - mag*0.5*xa;, xmax = xmax + mag*0.5*xa;
       ymin = ymin - mag*0.5*ya;, ymax = ymax + mag*0.5*ya;
    end
    
    set(gca,'XLim',[xmin xmax],'YLim',[ymin ymax]);  

    % Plot function value
    [x,y] = meshgrid(xmin:(xmax-xmin)/50:xmax,ymin:(ymax-ymin)/50:ymax);
    input = [x(:),y(:)];
    output=input*w'+b;
    z = reshape(output,size(x,1),size(x,2));
    l = (-min(min(z)) + max(max(z)))/2.0;
    sp = pcolor(x,y,z);
    shading interp  
    set(sp,'LineStyle','none');
    set(gca,'Clim',[-l  l],'Position',[0 0 1 1])
    axis off
    load cmap
    colmap=colmap(size(colmap,1):-1:1,:);
    colmap(:,1)=colmap(:,1)+.25;
    colmap(colmap>1)=1;
    colmap(:,3)=colmap(:,3)+.25;
    colmap(colmap>1)=1;
    colormap(colmap)

    % Plot Training points

    hold on
    for i = 1:size(Y)
      if (Y(i) == 1)
        plot(X(i,xaxis),X(i,yaxis),'r+','LineWidth',4) % Class A
      else
        plot(X(i,xaxis),X(i,yaxis),'b+','LineWidth',4) % Class B
      end
    end 
    for i = 1:size(Ytest)
      if (Ytest(i) == 1)
        plot(Xtest(i,xaxis),Xtest(i,yaxis),'rs','LineWidth',2) % Class A
      else
        plot(Xtest(i,xaxis),Xtest(i,yaxis),'bs','LineWidth',2) % Class B
      end
    end 
    for k=1:length(active_set)
        plot(X(active_set(k),xaxis),X(active_set(k),yaxis),'wo') % Support Vector
    end

    % Plot Boundary contour

    hold on
    contour(x,y,z,[0 0],'w')
    contour(x,y,z,[-1 -1],'w:')
    contour(x,y,z,[1 1],'w:')
    hold off


