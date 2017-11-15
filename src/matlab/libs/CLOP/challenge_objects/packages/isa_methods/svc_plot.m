function svc_plot(X,Y,ker,q,gamma,alpha,bias,aspect,mag,xaxis,yaxis,input,Xtest,Ytest,coef0)
%SVCPLOT Support Vector Machine Plotting routine
%
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
%  Modified: Isabelle Guyon - August/September 1999 - isabelle@clopinet.com
%  - Feb 2015 add coef0

  if (nargin < 7 || nargin > 15) % check correct number of arguments
    help svcplot; error('wrong number of arguments');
  else

    %scatterplot(X, (Y+1)/2); figure;
    p=length(alpha);
	 epsilon = 0.01*max(max(alpha))/p; 
    if nargin<14, Ytest=[]; end
    if nargin<13, Xtest=[]; end
    if (nargin < 12)||isempty(input) input = zeros(1,size(X,2)); end
    if (nargin < 11)||isempty(yaxis) yaxis = 2; end
    if (nargin < 10)||isempty(xaxis) xaxis = 1; end
    if (nargin < 9)||isempty(mag) mag = 0.1; end
    if (nargin < 8)||isempty(aspect) aspect = 0; end
    if (nargin < 9)coef0 = 0; end
    
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
    z = bias*ones(size(x));
    % All the test points
    input = [x(:),y(:)];
    if 1==2
    % Support vector indices:
	 sv = find(alpha > epsilon);
	 % Coefficients of the support vectors:
    sv_alpha = alpha(sv);
    % Vector and target values of the support vectors:
    sv_X = X(sv,:); sv_Y = Y(sv);
    % All dot products:
    DP = svc_dp(ker,input,sv_X,q,gamma,[],[],coef0);
    % All the discriminant function values:
    Z = DP*(sv_Y.*sv_alpha);
    end
    % Use all the patterns, even the non SV (more general)
    DP = svc_dp(ker,input,X,q,gamma,[],[],coef0);
    Z = DP*(Y.*alpha);
    z = z + reshape(Z,size(x,1),size(x,2));
    
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
      if (abs(alpha(i)) > epsilon)
        plot(X(i,xaxis),X(i,yaxis),'wo') % Support Vector
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

    hold on
    contour(x,y,z,[0 0],'w')
    contour(x,y,z,[-1 -1],'w:')
    contour(x,y,z,[1 1],'w:')
    hold off

  end    
