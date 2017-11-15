function svc_callback (message)

% svc_callback (message)
%
% This software is inspired by code written by 
% Malcolm Slaney (malcolm@interval.com)
% Interval Research Corporation
% (c) 1998 by Interval Research Corporationby Interval Research
% Corporation, but may be used, reproduced, modified and
% distributed by Licensee.  Licensee agrees that any copies of the
% software program will contain the same proprietary notices and
% warranty disclaimers which appear in this software program.
%
% Interval disclaimer:
% THIS SOFTWARE IS BEING PROVIDED TO YOU 'AS IS.'  INTERVAL MAKES
% NO EXPRESS, IMPLIED OR STATUTORY WARRANTY OF ANY KIND FOR THE
% SOFTWARE INCLUDING, BUT NOT LIMITED TO, ANY WARRANTY OF
% PERFORMANCE, MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.
% IN NO EVENT WILL INTERVAL BE LIABLE TO LICENSEE OR ANY THIRD
% PARTY FOR ANY DAMAGES, INCLUDING LOST PROFITS OR OTHER INCIDENTAL
% OR CONSEQUENTIAL DAMAGES, EVEN IF INTERVAL HAS BEEN ADVISED OF
% THE POSSIBLITY THEREOF.
%
% Isabelle Guyon - August 1999 - isabelle@clopinet.com -

global data

if nargin < 1
	message = 'Init';
end

switch(message)
case 'Clear',
					% Find the right axes
	h = findobj(gcbf,'Tag','DrawPoints');
	set(h,'UserData',[]);		% Remove all the points.
	cla				% Clear the plot
					
case 'Init',
   svc_gui
   set(findobj(gcbf, 'Tag','EditN'),'String','0.001');
	SetMethodEnables(findobj(gcf,'Tag','PopupMethod'));
	set(gcbf,'HandleVisibility','callback');


case 'DrawPoints',
	pt = get(gca, 'CurrentPoint');
	button = get(gcbf, 'SelectionType');
	x = pt(1,1);
	y = pt(1,2);

	fprintf('Got %s at %d,%d.\n', button, x, y);
	switch(button)
	case 'normal',			% Left Button = normal, Middle = extend, left = alt.
		value = -1;
		marker = 'x';
   otherwise			% Anything else
      value = 1;
		marker = 'o';
	end
	if value ~= 0
					% Add the new point to array
		h = findobj(gcbf, 'Tag','DrawPoints');
        global data
		data = get(h,'UserData');
		data = [data;x y value];
		set(h,'UserData',data);

		if value < 0
			t = text(x, y, marker, ...
				'HorizontalAlignment','Center', ...
				'Color',[1 0 0]);
		else
			t = text(x, y, marker, ...
				'HorizontalAlignment','Center', ...
				'Color',[0 0 1]);
		end
	end

case 'Go',
   global ISA;
   k = get(findobj(gcbf, 'Tag','PopupMethod'),'Value');
   ker_list = get(findobj(gcbf, 'Tag','PopupMethod'),'String');
   kernel = ker_list{k}
	q = eval(get(findobj(gcbf, 'Tag','EditQ'),'String'));
	gamma = eval(get(findobj(gcbf, 'Tag','EditG'),'String'));
	nu = eval(get(findobj(gcbf, 'Tag','EditN'),'String'));

	h = findobj('Tag','DrawPoints');
	data = get(h,'UserData');
    fprintf('data=[\n');
    for k=1:size(data,1)
        fprintf('\t%g', data(k,:));
        fprintf('\n');
    end
    fprintf('];\n');
					
   set(gcbf,'HandleVisibility','off');
   h=figure;
   if(isempty(ISA)),
   	%[Alpha, Bias, kernel, q, gamma, C, Vcdim] = ...
         %svc_train(data(:,1:2),data(:,3),kernel,q,gamma,1/nu);
         %nu=1/C;
      [Alpha, Bias, kernel, q, gamma, C, Vcdim] = ...
         svc_train(data(:,1:2),data(:,3),kernel,q,gamma,[],nu);
  	set(h,  'Name',['kernel=', kernel, ' - q=', num2str(q), ', gamma=' , num2str(gamma),', nu=',num2str(nu),', vcdim=',num2str(Vcdim(1))]);
   	svc_plot(data(:,1:2),data(:,3),kernel,q,gamma,Alpha,Bias);
   else
      %net = nn_train(data(:,1:2),data(:,3));
      %nn_plot(data(:,1:2),data(:,3),net);
      [w, b, active_set] = slm(data(:,1:2),data(:,3));
      ld_plot(data(:,1:2),data(:,3),w,b, active_set);
   end
   the_date=datestr(now); the_date(the_date==' ')='_';
   if exist('XY.mat', 'file')
        movefile('XY.mat', ['XY_' the_date '.mat']);
   end
   X=data(:,1:2);
   Y=data(:,3);
   save('XY', 'X', 'Y');

   set(gcbf,'HandleVisibility','callback');

case 'Help',
	fprintf('Got the Help button.\n');
svchelpstr = {
   'This is a simple Graphical User Interface for Support Vector Classifiers.'
   'The code was written by Isabelle Guyon, but is inspired by code written'
   'by Malcom Slaney and by Steve Gunn.'
   ' '
'When you call the SVC GUI (using the svc_gui command) you get a window,'
'which allows a user to specify points on a two-dimensional grid'
'and to control the SVC program.  The results are displayed in another'
'window.' 
' '
'The blank area on the Support Vector Controller window is used to enter'
'points to be classified.  The left mouse button puts down red points, and'
'the middle button (or right if you have two buttons) puts down blue points.'
' '
'The popup menu on the upper right allows you to specify the type of '
'kernel function you would like to use. '
' '
'The parameters have default values suitable for most applications.'
'-- Degree p: This controls the influence of products (correlations) of'
'input features. Because of the combinatorial explosion, degrees higher'
'than two are seldom useful unless the input space is of small dimension.'
'A degree 0 means a pure radial kernel. A degree 1 with a locality 0'
'correspond to a linear classifier.'
'-- Locality gamma: This controls the radius of influence of each pattern,'
'relative the largest distance between patterns. A locality of 0 means'
'a pure polynomial classifier. If the problem is composed of many local'
'sub-problems illustrated by different type of patterns it makes sense to'
'increase locality.'
'-- Soft margin nu: This controls how strictly the optimum margin criterion'
'is enforced, allowing for a certain number of patterns to fall within the'
'margin boundaries or be misclassified. If the data is noisy, contains errors'
'or uncertainties is the labeling, it makes sense to increase nu.'
' '
'The "GO" button calls the svc program to do the work and plot the'
'results. '
};
	helpwin(svchelpstr,'SVC GUI Help');

case 'NewMethod',
	h = findobj(gcbf, 'Tag','PopupMethod');
	SetMethodEnables(h)

otherwise,
	fprintf('Unknown message %s to svc_callback.\n', message);
end

function SetMethodEnables(h)
	method = get(h,'Value');
	if length(method) < 1
		fprintf('Couldn''t find the Method Popup''s value.\n');
		return;
	end
	% fprintf('Changed the method to %d.\n',method);
	set(findobj('Tag','EditN'),'Enable','on');
	switch (method)
	case 1,				% Linear
		set(findobj(gcbf, 'Tag','EditQ'),'Enable','off');
      set(findobj(gcbf, 'Tag','EditG'),'Enable','off');
      set(findobj(gcbf, 'Tag','EditQ'),'String','1');
      set(findobj(gcbf, 'Tag','EditG'),'String','0');
	case 2,				% Polynomial
		set(findobj(gcbf, 'Tag','EditQ'),'Enable','on');
      set(findobj(gcbf, 'Tag','EditG'),'Enable','off');
      set(findobj(gcbf, 'Tag','EditQ'),'String','2');
      set(findobj(gcbf, 'Tag','EditG'),'String','0');
	case 3,				% Radial
		set(findobj(gcbf, 'Tag','EditQ'),'Enable','off');
      set(findobj(gcbf, 'Tag','EditG'),'Enable','on');
      set(findobj(gcbf, 'Tag','EditQ'),'String','0');
      set(findobj(gcbf, 'Tag','EditG'),'String','1');
	case 4,				% General
		set(findobj(gcbf, 'Tag','EditQ'),'Enable','on');
      set(findobj(gcbf, 'Tag','EditG'),'Enable','on');
      set(findobj(gcbf, 'Tag','EditQ'),'String','2');
      set(findobj(gcbf, 'Tag','EditG'),'String','1');
	end
		

