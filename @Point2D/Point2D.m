classdef Point2D < dlnode
   properties
     Coords
   end
   
   methods
       function point = Point2D(id, xy)
           if nargin == 0
              id = [];
              xy = [];
           end
           point = point@dlnode(id);
           
           point.Coords = xy;
       end
   end
end
