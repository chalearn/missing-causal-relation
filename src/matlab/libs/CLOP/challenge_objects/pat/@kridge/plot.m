function plot(a, d)
%PLOT Support Vector Machine Plotting routine
% a=svc object
% d=data
%
%  Inspired by original svc-plot
%  Usage: svc_plot(X,Y,ker,q,gamma,alpha,bias,aspect,mag,xaxis,yaxis,input,Xtest,Ytest,coef0)
%
%  Parameters: X      - Training inputs
%              Y      - Training targets
%              ker    - Kernel function
%              q      - Polynomial degree in kernel function
%              gamma  - Locality parameter in kernel function
%              alpha  - Lagrange Multipliers
%              bias   - Bias term 
%              aspect - Aspect Ratio (default: 0 (fixed), 1 (variable))
%              mag    - Display magnification 
%              xaxis  - xaxis input (default: 1) 
%              yaxis  - yaxis input (default: 2)
%              input  - Vector of input values (default: zeros(no_of_inputs))
%              Xtest  - Input test matrix
%              Ytest  - Test target vector
%              coef0  - bias value for backward compatibility with libsvm

%  Author: Steve Gunn (srg@ecs.soton.ac.uk)
%  Modified: Isabelle Guyon - August/September 1999 - 2008 - isabelle@clopinet.com -

    figure;
    X=get_x(d);
    Y=get_y(d);
    alpha=a.alpha;
    bias=a.b0;

    p=length(alpha);
	epsilon = 0.01*max(max(alpha))/p; 
    Ytest=[];
    Xtest=[]; 
    input = zeros(1,size(X,2));
    yaxis = 2;
    xaxis = 1;
    mag = 0.1;
    aspect = 0;
    
    % Scale the axes
    xmin = min(X(:,xaxis)); xmax = max(X(:,xaxis)); 
    ymin = min(X(:,yaxis)); ymax = max(X(:,yaxis)); 
    if ~isempty(Xtest)
        xmint = min(Xtest(:,xaxis)); xmaxt = max(Xtest(:,xaxis)); 
        ymint = min(Xtest(:,yaxis)); ymaxt = max(Xtest(:,yaxis));
        xmin=min(xmin,xmint); xmax=max(xmax,xmaxt);
        ymin=min(ymin,ymint); ymax=max(ymax,ymaxt);
    end
    xa = (xmax - xmin); ya = (ymax - ymin);
    if (~aspect)
       if (0.75*abs(xa) < abs(ya)) 
          offadd = 0.5*(ya*4/3 - xa); 
          xmin = xmin - offadd - mag*0.5*ya; xmax = xmax + offadd + mag*0.5*ya;
          ymin = ymin - mag*0.5*ya; ymax = ymax + mag*0.5*ya;
       else
          offadd = 0.5*(xa*3/4 - ya); 
          xmin = xmin - mag*0.5*xa; xmax = xmax + mag*0.5*xa;
          ymin = ymin - offadd - mag*0.5*xa; ymax = ymax + offadd + mag*0.5*xa;
       end
    else
       xmin = xmin - mag*0.5*xa; xmax = xmax + mag*0.5*xa;
       ymin = ymin - mag*0.5*ya; ymax = ymax + mag*0.5*ya;
    end
    
    set(gca,'XLim',[xmin xmax],'YLim',[ymin ymax]);  

    % Plot function value

    [x,y] = meshgrid(xmin:(xmax-xmin)/50:xmax,ymin:(ymax-ymin)/50:ymax); 
    %z = bias*ones(size(x)); %makes no sense
    % All the test points
    input = [x(:),y(:)];

    % Use all the patterns, even the non SV (more general)
    %DP = svc_dp(ker,input,X,q,gamma);
    %Z = DP*(Y.*alpha);
    out=test(a, data(input));
    Z=out.X;    
    %z = z + reshape(Z,size(x,1),size(x,2));
    z = reshape(Z,size(x,1),size(x,2));

    % Background
    sp = pcolor(x,y,z);
    shading interp  
    %set(sp,'LineStyle','none');
    %axis off
    load cmap
    colormap(colmap)
    l = (-min(min(z)) + max(max(z)))/2;
    %set(gca,'Clim',[-l  l],'Position',[0 0 1 1])
    set(gca, 'Clim',[-l l])
    %set(gcf, 'Position', [360 260 460 460]);
    
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

    % Plot Boundary contour
    contour(x,y,z,[0 0],'w')
    contour(x,y,z,[-1 -1],'w:')
    contour(x,y,z,[1 1],'w:')
    
  end    
