classdef EdgeEnt < dlnode
   properties
       pBegin
       pEnd
       
       midPoint
       
       mRef = 0
       mCoar = 0
   end
   
   properties(SetAccess = private)
       lFace = FaceEnt.empty
       rFace = FaceEnt.empty
       
       childEdge1 = EdgeEnt.empty
       childEdge2 = EdgeEnt.empty
       
       parentEdge = EdgeEnt.empty
   end 
   
   methods
       function edge = EdgeEnt(id, p0, p1)
          if nargin == 0
             id = [];
             p0 = Point2D.empty;
             p1 = Point2D.empty;
          end
          edge = edge@dlnode(id);
          edge.pBegin = p0;
          edge.pEnd = p1;
       end
       
       function set_adjacent_faces(edge, face, orient)
           if orient == 1
               edge.lFace = face;
           elseif orient == -1
               edge.rFace = face;
           end
       end
       
       function mark_refine(edge)
           edge.mRef = 1;  
       end
       
       function mark_coarsen(edge)
           edge.mCoar = 1;
       end
       
       function refine_edge(p_edge)
          mid_coords = 0.5 * (p_edge.pBegin.Coords + p_edge.pEnd.Coords);
          
          pmid = Point2D([p_edge.iD, 1], mid_coords);
          
          pmid.insertAfter(p_edge.pBegin);
          
          p_edge.childEdge1 = EdgeEnt([p_edge.iD, 1], p_edge.pBegin, pmid);
          p_edge.childEdge2 = EdgeEnt([p_edge.iD, 2], pmid, p_edge.pEnd);
          
          p_edge.childEdge1.parentEdge = p_edge;
          p_edge.childEdge2.parentEdge = p_edge;
          
          
          p_edge.childEdge1.insertAfter(p_edge);
          
          p_edge.childEdge2.insertAfter(p_edge.childEdge1);
%           removeNode(p_edge);
       end
       
       function coarsen_edge(edge)
          pEdge = edge.parentEdge;
          
          prevEdge = pEdge.childEdge1.Prev;
          
          pEdge.childEdge1.pEnd.removeNode();
          
          pEdge.childEdge1.removeNode();
          
          pEdge.childEdge2.removeNode();
          
          pEdge.insertAfter(prevEdge);
          
          pEdge.childEdge1 = EdgeEnt.empty;
          pEdge.childEdge2 = EdgeEnt.empty;
       end
       
   end
end