function marker = mark_circle(cent, rad, mesh_set)

    [~, ele] = mesh_set.refine_uniform(0);
    
    marker = false(size(ele, 1), 1);
    
    fct = 1;
    face = mesh_set.headFace.Next;
    while face.iD ~= -10
        v = face.get_vertices();
        
        a = v(1, :) - v(3, :);
        b = v(2, :) - v(4, :);
        
        a = sqrt(sum(a.^2));
        b = sqrt(sum(b.^2));
        
        
        tol = max(a, b);
        
        fc = 0.25 * sum(v);
%         r = (fc(1) - cent(1))^2 + (fc(2) - cent(2))^2;
        
        r = sqrt(sum((fc - cent).^2));
        
        if abs(r - rad) < abs(tol/2 + 1e-3)
            marker(fct, 1) = true;
        end
        
%         a1 = (v(3, 1) - v(1, 1))^2 + (v(3, 2) - v(1, 2))^2;
%         a2 = (v(4, 1) - v(2, 1))^2 + (v(4, 2) - v(2, 2))^2;
%         
%         b1 = 2 * v(1, 1) * (v(3, 1) - v(1, 1)) + 2 * v(1, 2) * (v(3, 2) - v(1, 2));
%         b2 = 2 * v(2, 1) * (v(4, 1) - v(2, 1)) + 2 * v(2, 2) * (v(4, 2) - v(2, 2));
%         
%         c1 = v(1, 1)^2 + v(1, 2)^2 - rad^2;
%         c2 = v(2, 1)^2 + v(2, 2)^2 - rad^2;
%         
%         d1 = b1^2 - 4 * a1 * c1;
%         d2 = b2^2 - 4 * a2 * c2;
%         
%         t1 = [0, 0];
%         t2 = [0, 0];
% 
%         if d1 >= 0
%            t1(2) = (-b1 + sqrt(d1)) / (2 * a1);
%            t1(1) = (-b1 - sqrt(d1)) / (2 * a1); 
%            if (0 <= t1(1) && t1(1) <= 1) || (0 <= t1(2) && t1(2) <= 1)
%                marker(fct, 1) = true;
%            end
%         end
%         
%         if d2 >= 0
%            t2(2) = (-b2 + sqrt(d2)) / (2 * a2);
%            t2(1) = (-b2 - sqrt(d2)) / (2 * a2); 
%            if (0 <= t2(1) && t2(1) <= 1) || (0 <= t2(2) && t2(2) <= 1)
%                marker(fct, 1) = true;
%            end
%          end

        face = face.Next;
        fct = fct + 1;
    end
    
    theta = linspace(0, 2 * pi, 100);

    x = rad * cos(theta);
    y = rad * sin(theta);
    
    plot(x, y, 'r-', 'linewidth', 2)
    
end

