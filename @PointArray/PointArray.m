classdef PointArray
    properties
        point
    end
    methods
        function obj = PointArray(head_point, coords)
            if nargin > 0
               np = size(coords, 1);
               obj(np, 1) = PointArray;
               for i = np:-1:1
                  obj(i).point = Point2D(i, coords(i, :));
                  obj(i).point.insertAfter(head_point);
               end
            end
        end
    end
end

