classdef FaceEnt < dlnode
   properties
      Edges
      Orient
      
      mRef = 0;
      mCoar = 0;
      lEvel = 0;
   end
   
   properties(SetAccess = private)
       southEast = FaceEnt.empty
       northEast = FaceEnt.empty
       northWest = FaceEnt.empty
       southWest = FaceEnt.empty
       
       parentFace = FaceEnt.empty
   end 
   
   methods
       function face = FaceEnt(id, edges)
          if nargin == 0
             id = [];
             edges = [EdgeEnt.empty, ...
                      EdgeEnt.empty,...
                      EdgeEnt.empty,...
                      EdgeEnt.empty];
          end
          face = face@dlnode(id);
          
          face.Edges = edges;
       end
       
       function mark_refine(face)
         if face.mRef ~= 1
             face.mRef = 1;
         end
         for i = 1:4
             face.Edges(i).mark_refine();
             if ~isempty(face.Edges(i).parentEdge)
                 pEdge = face.Edges(i).parentEdge;
                 if ~isempty(pEdge.Prev) || ~isempty(pEdge.Next)
                     if face.Orient(i) == 1
                       mark_refine(pEdge.rFace);

                     else
                       mark_refine(pEdge.lFace); 
                     end                      
                 end
             end
         end
       end
       
       function mark_coarsen(face)
          pFace = face.parentFace;
          if ~isempty(pFace)
            mark = false;
            cFaces = [pFace.southEast, pFace.northEast, pFace.northWest, pFace.southWest];
            for i = 1:4
                if ~isempty(cFaces(i).southEast)
                    cFaces(i).southEast.mark_coarsen();
                    mark = true;
                end
            end 
            if ~mark
                face.mCoar = 0;
            end 
          end
       end
       
       function set_orient(face, orient)
          face.Orient = orient; 
       end
       
       function refine_face(face)
          c_b = 0.5 * (face.Edges(1).pBegin.Coords + face.Edges(1).pEnd.Coords);
          c_t = 0.5 * (face.Edges(3).pBegin.Coords + face.Edges(3).pEnd.Coords);
          
          coords = zeros(4, 2);
          
          for i = 1:4
             if face.Orient(i) == 1
                 coords(i, :) = face.Edges(i).pBegin.Coords(:, :);
             else
                 coords(i, :) = face.Edges(i).pEnd.Coords(:, :);
             end
          end
          
%           c_mid = 0.25 * sum(coords);
          
          
          
% 
          c_mid = 0.5 * (c_b + c_t);
              
          centerPoint = Point2D([face.iD, 1], c_mid);
          
          heads = [EdgeEnt(), EdgeEnt(), EdgeEnt(), EdgeEnt()];
          
          for i = 1:4
              if isempty(face.Edges(i).childEdge1)
                  refine_edge(face.Edges(i));
                  heads(i).insertBefore(face.Edges(i).childEdge1);
                  if isempty(face.Edges(i).rFace) || isempty(face.Edges(i).lFace)
                     removeNode(face.Edges(i)) 
                  end
                  
              else                  
                  heads(i).insertBefore(face.Edges(i));
                  
                  removeNode(face.Edges(i));                 
              end
          end
          
%           centerPoint.insertAfter(heads(4).Next.pEnd);
          
          
          ed = [EdgeEnt(), EdgeEnt();
                EdgeEnt(), EdgeEnt();
                EdgeEnt(), EdgeEnt();
                EdgeEnt(), EdgeEnt()];
          
           for i = 1:4
              if(face.Orient(i) == 1)
                  ed(i, 1) = heads(i).Next;
                  ed(i, 2) = heads(i).Next.Next;
              else
                  ed(i, 1) = heads(i).Next.Next;
                  ed(i, 2) = heads(i).Next;
              end
           end
          
           centerPoint.insertAfter(ed(4, 2).pEnd);
          
              
          cedge1 = EdgeEnt([face.iD, 1], heads(1).Next.pEnd, centerPoint);
          cedge2 = EdgeEnt([face.iD, 2], centerPoint, heads(2).Next.pEnd);
          cedge3 = EdgeEnt([face.iD, 3], centerPoint, heads(3).Next.pEnd);
          cedge4 = EdgeEnt([face.iD, 4], heads(4).Next.pEnd, centerPoint);
          
          cedge1.insertAfter(heads(4).Next.Next);
          cedge2.insertAfter(cedge1);
          cedge3.insertAfter(cedge2);
          cedge4.insertAfter(cedge3);
          
          
                                 
          edges1 = [ed(1, 2), ed(2, 1), cedge2, cedge1];
          orient1 = [face.Orient(1), face.Orient(2), -1, -1];
          

          edges2 = [cedge2, ed(2, 2), ed(3, 1), cedge3];
          orient2 = [1, face.Orient(2), face.Orient(3), -1];

          edges3 = [cedge4, cedge3, ed(3, 2), ed(4, 1)];
          orient3 = [1, 1, face.Orient(3), face.Orient(4)];

          edges4 = [ed(1, 1), cedge1, cedge4, ed(4, 2)];
          orient4 = [face.Orient(1), 1, -1, face.Orient(4)];

          face.southEast = FaceEnt([face.iD, 1], edges1);
          face.southEast.Orient = orient1;
%           face.southEast.lEvel = face.lEvel + 1;
              
          face.northEast = FaceEnt([face.iD, 2], edges2);
          face.northEast.Orient = orient2;
%           face.northEast.lEvel = face.lEvel + 1;

          face.northWest = FaceEnt([face.iD, 3], edges3);
          face.northWest.Orient = orient3;
%           face.northWest.lEvel = face.lEvel + 1;

          face.southWest = FaceEnt([face.iD, 4], edges4);
          face.southWest.Orient = orient4;
%           face.southWest.lEvel = face.lEvel + 1;
          
          cedge1.set_adjacent_faces(face.southEast, -1);
          cedge1.set_adjacent_faces(face.southWest, 1);
          
          cedge2.set_adjacent_faces(face.southEast, -1);
          cedge2.set_adjacent_faces(face.northEast, 1);
          
          cedge3.set_adjacent_faces(face.northEast, -1);
          cedge3.set_adjacent_faces(face.northWest, 1);
          
          cedge4.set_adjacent_faces(face.northWest, 1);
          cedge4.set_adjacent_faces(face.southWest, -1);
          
          ff = [face.southWest, face.southEast; 
                face.southEast, face.northEast;
                face.northEast, face.northWest;
                face.northWest, face.southWest];
          
          for i = 1:4
              
              if(face.Orient(i) == 1)  
                 ed(i, 1).set_adjacent_faces(ff(i, 1), 1);
                 ed(i, 2).set_adjacent_faces(ff(i, 2), 1);
%                  ed(i, 1).set_adjacent_faces(face.Edges(i).rFace, -1);
%                  ed(i, 2).set_adjacent_faces(face.Edges(i).rFace, -1);  
              else
                 ed(i, 1).set_adjacent_faces(ff(i, 1), -1);
                 ed(i, 2).set_adjacent_faces(ff(i, 2), -1);
%                  ed(i, 1).set_adjacent_faces(face.Edges(i).lFace, 1);
%                  ed(i, 2).set_adjacent_faces(face.Edges(i).lFace, 1);
              end
          end
          
          face.southEast.parentFace = face;
          face.northEast.parentFace = face;
          face.northWest.parentFace = face;
          face.southWest.parentFace = face;

          face.southEast.insertAfter(face);
          face.northEast.insertAfter(face.southEast);
          face.northWest.insertAfter(face.northEast);
          face.southWest.insertAfter(face.northWest);
              
          removeNode(face);
          removeNode(heads(1));
          removeNode(heads(2));
          removeNode(heads(3));
          removeNode(heads(4));
       end
       
       function vertices = get_vertices(face)
           vertices = zeros(4, 2);
           
           for i = 1:4
              if face.Orient(i) == 1
                 vertices(i, :) = face.Edges(i).pBegin.Coords;
              else
                  vertices(i, :) = face.Edges(i).pEnd.Coords;
              end
           end
       end
       function coarsen_faces(face)
          %% get parent face and the previous face to its first child face (southEast)
          pFace = face.parentFace;
          prevFace = pFace.southEast.Prev;
          
          %% Remove child faces (which includes face itself)
          pFace.southEast.removeNode();
          pFace.northEast.removeNode();
          pFace.northWest.removeNode();
          pFace.southWest.removeNode();
          
          
          
          %% Remove central edges (they don't have children)
          pFace.southEast.Edges(3).removeNode(); % cedge2
          pFace.southEast.Edges(4).removeNode(); % cedge1        
          pFace.northWest.Edges(1).removeNode(); % cedge4
          pFace.northWest.Edges(2).removeNode(); % cedge3
          
          %% Coarsen edges of parent face
          for i = 1:4
             if pFace.Orient(i) == 1
                 if isempty(pFace.Edges(i).childEdge1.rFace)
                    coarsen_edge(pFace.Edges(i).childEdge1); 
                 else
                     pFace.Edges(i).childEdge1.lFace = FaceEnt.empty;
                     pFace.Edges(i).childEdge2.rFace = FaceEnt.empty;
                 end
                   
             else
                 if isempty(pFace.Edges(i).childEdge1.lFace)
                    coarsen_edge(pFace.Edges(i).childEdge1); 
                 else
                    pFace.Edges(i).childEdge1.rFace = FaceEnt.empty;
                    pFace.Edges(i).childEdge2.rFace = FaceEnt.empty;
                 end
             end
          end
          
          %% Remove the central point
          pFace.southEast.Edges(3).pBegin.removeNode();
          
          %% Insert the parent face after the previous face
          pFace.insertAfter(prevFace);
          
          %% remove the parentFace handle to the child Faces
          pFace.southEast.parentFace = FaceEnt.empty;
          pFace.northEast.parentFace = FaceEnt.empty;
          pFace.southWest.parentFace = FaceEnt.empty;
          pFace.northWest.parentFace = FaceEnt.empty;
          
          %% remove the child faces from the tree
          pFace.southEast = FaceEnt.empty;
          pFace.northEast = FaceEnt.empty;
          pFace.northWest = FaceEnt.empty;
          pFace.southWest = FaceEnt.empty;    
          
       end
   end
end

