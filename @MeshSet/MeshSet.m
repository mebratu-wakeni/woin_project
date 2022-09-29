classdef MeshSet < handle

    
    properties
        headPoint = Point2D();
        tailPoint = Point2D();
        
        headEdge = EdgeEnt();
        tailEdge = EdgeEnt();
        
        headFace = FaceEnt();
        tailFace = FaceEnt();
        
%         Coords
%         Elements
        cYcle = 0;
        
        faceArray
    end
    
    methods
        function  mesh_set = MeshSet(coords, elements)
            mesh_set.cYcle = 0;
            mesh_set.headPoint.iD = 0;
            mesh_set.tailPoint.iD = -10;
            
            mesh_set.tailPoint.insertAfter(mesh_set.headPoint);
            
            ptArr = PointArray(mesh_set.headPoint, coords);
            
            mesh_set.headEdge.iD = 0;
            mesh_set.tailEdge.iD = -10;
            
            mesh_set.tailEdge.insertAfter(mesh_set.headEdge);
            edArr = EdgeArray(mesh_set.headEdge, ptArr, elements);
            
            
            mesh_set.headFace.iD = 0;
            mesh_set.tailFace.iD = -10;
            mesh_set.tailFace.insertAfter(mesh_set.headFace);
            
            mesh_set.faceArray = FaceArray(mesh_set.headFace, edArr, elements);
            
            
            
        end
        
        function [COORDS, ELEMENTS] = refine_uniform(mesh_set, n)
            
           for cycle = 1:n
               face = mesh_set.headFace.Next;
               while face.iD ~= -10
                  ftmp = face.Prev;
                  face.mark_refine();
                  face.refine_face();
                  face = ftmp.Next.Next.Next.Next.Next;
               end
               
           end
           
           mesh_set.renumber();
           
           
           
           nb_pts = mesh_set.tailPoint.Prev.iD;
           
           COORDS = zeros(nb_pts, 2);
           mesh_set.tailPoint.iD = -10;
           point = mesh_set.headPoint.Next;
           while point.iD ~= -10
               pid = point.iD;
               COORDS(pid, :) = point.Coords;
               point = point.Next;
           end
           

           
           nb_fcs = mesh_set.tailFace.Prev.iD;
           
           ELEMENTS = zeros(nb_fcs, 4, 'uint32');   
           face = mesh_set.headFace.Next; 
           
           while face.iD ~= -10
              fid = face.iD; 
              for i = 1:4
                 if face.Orient(i) == 1
                    ELEMENTS(fid, i) = face.Edges(i).pBegin.iD;
                 else
                    ELEMENTS(fid, i) = face.Edges(i).pEnd.iD; 
                 end
              end
              face = face.Next;
           end   
        end
        
        function renumber(mesh_set)
            point = mesh_set.headPoint.Next;
            
            pct = 1;
            while point.iD ~= -10
               point.iD = pct;
               pct = pct + 1;
               point = point.Next;
            end
            
%             edge = mesh_set.headEdge.Next;
%             ect = 1;
%             while edge.iD ~= -10
%                edge.iD = ect;
%                ect = ect + 1;
%                edge = edge.Next;
%             end
            
            face = mesh_set.headFace.Next;
            fct = 1;
            while face.iD ~= -10
               face.iD = fct;
               fct = fct + 1;
               face = face.Next;
            end
        end
        
        function mark_refine(mesh_set, markers)
            
          fct = 1;
          face = mesh_set.headFace.Next;
          while face.iD ~= -10
              if markers(fct)
                  face.mark_refine();
              end
              fct = fct + 1;
              face = face.Next;
          end          
        end
        
        function mark_coarsen(mesh_set, markers)
           fct = 1;
           face = mesh_set.headFace.Next;
           
           while face.iD ~= -10
              if markers(fct)
                  face.mark_coarsen()
              end
              fct = fct + 1;
              face = face.Next;
           end
        end
        
        function show_mesh(mesh_set)
            coords = mesh_set.Coords;
            eles = mesh_set.Elements;
            
            whos coords
            
            plot(coords(:, 1), coords(:, 2), 'ko', 'MarkerFaceColor', 'k', 'MarkerSize', 1)
            P = patch('Faces', eles, 'Vertices', coords, 'Facecolor', 'none');
            set(P, 'Facecolor', 'c', 'FaceAlpha', 0.5)
            set(P, 'Edgecolor', 'k', 'Linewidth', 1)
            axis off
            grid off
            
            
        end
        
        function [COORDS, ELEMENTS] = refine_marked(mesh_set)
           mesh_set.cYcle = mesh_set.cYcle + 1;
           n = mesh_set.cYcle;
           for i = 0:1:n
              face = mesh_set.headFace.Next;
              while face.iD ~= -10
                 if face.lEvel == i
                    if face.mRef == 1
                       ftmp = face.Prev;
                       face.refine_face();
                       ftmp.Next.lEvel = face.lEvel + 1;
                       ftmp.Next.Next.lEvel = face.lEvel + 1;
                       ftmp.Next.Next.Next.lEvel = face.lEvel + 1;
                       ftmp.Next.Next.Next.Next.lEvel = face.lEvel + 1;
                       face = ftmp.Next.Next.Next.Next;
                    end
                 end
                 face = face.Next;
              end 
           end
           
           
           
           mesh_set.renumber();
           
           nb_pts = mesh_set.tailPoint.Prev.iD;
           
           COORDS = zeros(nb_pts, 2);
           mesh_set.tailPoint.iD = -10;
           point = mesh_set.headPoint.Next;
           while point.iD ~= -10
               pid = point.iD;
               COORDS(pid, :) = point.Coords;
               point = point.Next;
           end
           

           
           nb_fcs = mesh_set.tailFace.Prev.iD;
           
           ELEMENTS = zeros(nb_fcs, 4, 'uint32');   
           face = mesh_set.headFace.Next; 
           
           while face.iD ~= -10
              fid = face.iD; 
              for i = 1:4
                 if face.Orient(i) == 1
                    ELEMENTS(fid, i) = face.Edges(i).pBegin.iD;
                 else
                    ELEMENTS(fid, i) = face.Edges(i).pEnd.iD; 
                 end
              end
              face = face.Next;
           end  
        end
        
    end   
end

