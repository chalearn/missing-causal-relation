function d = calc(e,d)
   if isa(d,'cell')
     for i=1:length(d)
       d{i}=feval(e.type,e,d{i});
     end
   else
     d=feval(e.type,e,d);
   end
   