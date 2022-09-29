classdef FaceArray
    
    properties
        face
    end
    
    methods
        function obj = FaceArray(edge_array, elements)
            if nargin > 0
                nf = size(elements, 1);
                E = [elements(:, [1, 2]);...
                     elements(:, [2, 3]);...
                     elements(:, [3, 4]);...
                     elements(:, [4, 1])];
                E = sort(E, 2);
                [~, ie, ~] = unique(E, 'rows', 'stable');
                obj(nf).face = FaceEnt;
                
                tail_face = FaceEnt();
                
                for ff = 1:nf
                    ee = [elements(ff, [1, 2]);...
                          elements(ff, [2, 3]);...
                          elements(ff, [3, 4]);...
                          elements(ff, [4, 1])];
                    
                    orient = [1, 1, 1, 1];
                    edges = [EdgeEnt, EdgeEnt, EdgeEnt, EdgeEnt];
                    for i = 1:4
                        f = ff + (i-1)*nf;
                        edges(i) = edge_array(ie(f)).edge; 
                        if edges(i).iD(1) ~= ee(i, 1)
                            orient(i) = -1;
                        end
                    end
                    obj(ff).face = FaceEnt(ff, edges);
                    obj(ff).face.Orient = orient;
                    for i = 1:4
                       if orient(i) == 1
                          if isempty(edges(i).lFace)
                              edges(i).set_adjacent_faces(obj(ff).face, 'left');
                          end
                       else
                           if isempty(edges(i).rFace)
                               edges(i).set_adjacent_faces(obj(ff).face, 'right');
                           end
                       end
                    end
                    obj(ff).face.insertBefore(tail_face);
                end  
            end
        end
    end
end

