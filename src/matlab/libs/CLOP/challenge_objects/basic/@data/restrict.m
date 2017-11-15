
function dt = restrict(d, fidx)
   
%   function dt = restrict(d, fidx)
%   
%   restrict data matrix do givn feature indices
  
x=get_x(d);
y=get_y(d);
x=x(:, fidx);
dt=data(x, y);
