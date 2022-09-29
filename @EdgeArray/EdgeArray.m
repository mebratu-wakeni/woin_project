classdef EdgeArray
    
    properties
        edge
    end
    
    methods
        function obj = EdgeArray(head_edge,point_array, el)
           if nargin > 0
              E = [el(:, [1, 2]);...
                   el(:, [2, 3]);...
                   el(:, [3, 4]);...
                   el(:, [4, 1])];
                E = sort(E, 2);
                [C, ~, ~] = unique(E, 'rows', 'stable'); 
                ne = size(C, 1);
                obj(ne).edge = EdgeEnt;
                p = [point_array.point];
                for e = ne:-1:1
                    p1 = p(C(e, 1));
                    p2 = p(C(e, 2));
                    Id = C(e, :);
                    obj(e).edge = EdgeEnt(Id, p1, p2);
                    
                    obj(e).edge.insertAfter(head_edge);
                end
           end
        end
    end
end

