function show_marked(mesh_set)

   [coo, ele] = mesh_set.refine_uniform(0);
   
   mark = false(size(ele, 1), 1);
   smarker = false(size(ele, 1), 1);
   
   
   face = mesh_set.headFace.Next;
    fct = 1;
    while face.iD ~= -10
        if face.mRef == 1
        mark(fct, 1) = true;
           if mark(fct, 1) == 0
              smarker(fct, 1) = true; 
           end
        end
        fct = fct + 1;
        face = face.Next;
    end
    
    mF = ele(mark, :);
    
    unmark = logical(1 - mark);
    unmF = ele(unmark, :);
    
    N = size(ele, 1);
    
    cent = zeros(N, 2);
    
    for i = 1:N
       cent(i, :) = 0.25 * sum(coo(ele(i, :), :)); 
    end
    
    xoff = 0.00; yoff = 0.00;
    
    I = (1:size(ele, 1))';
    
    
    
    
    
    smarker = false(size(ele, 1), 1);
    
    
    
    secFaces = ele(smarker, :);
    
    
    
    
    
    
%     
%     str = strtrim(cellstr(num2str(I(:, :))));
%     hTxt = text(cent(:, 1)+xoff, cent(:, 2)+yoff, str, ...
%     'FontSize',12, 'FontWeight','bold', ...
%     'HorizontalAlign','center', 'VerticalAlign','middle');
% 
%     e = cell2mat(get(hTxt, {'Extent'}));
%     
%     p = e(:,1:2) + e(:,3:4)./2;
%     
%     line('XData',p(:,1), 'YData',p(:,2), ...
%     'LineStyle','none', 'Marker','o', 'MarkerSize',20, ...
%     'MarkerFaceColor','none', 'MarkerEdgeColor','k'); 

    
    
    P = patch('Faces', mF, 'Vertices', coo, 'Facecolor', 'none');
    set(P, 'Facecolor', 'r', 'FaceAlpha', 0.5)
    set(P, 'Edgecolor', 'k', 'Linewidth', 1)
%     
    P = patch('Faces', unmF, 'Vertices', coo, 'Facecolor', 'none');
    set(P, 'Facecolor', 'c', 'FaceAlpha', 0.5)
    set(P, 'Edgecolor', 'k', 'Linewidth', 1)
%     
    P = patch('Faces', secFaces, 'Vertices', coo, 'Facecolor', 'none');
    set(P, 'Facecolor', 'b', 'FaceAlpha', 0.5)
    set(P, 'Edgecolor', 'k', 'Linewidth', 1)
    
%     P = patch('Faces', ele, 'Vertices', coo, 'Facecolor', 'none');
%     set(P, 'Facecolor', 'c', 'FaceAlpha', 0.5)
%     set(P, 'Edgecolor', 'k', 'Linewidth', 1)
    axis off
    axis equal
    grid off
end

