clear all;
close all;
clc;

% COORDS= [-1.0, -1.0;...
%           0.0,-1.0;...
%          -1.0, 0.0;...
%           0.0, 0.0;...
%           1.0, 0.0;...
%          -1.0, 1.0;...
%           0.0, 1.0;...
%           1.0, 1.0];
%       
% ELEMENTS = [1, 2, 4, 3;...
%             8, 7, 4, 5;...
%             6, 3, 4, 7];

 
COORDS = [-1, -1; 1, -1; 1, 1; -1, 1];
ELEMENTS = [1, 2, 3, 4];
meshSet = MeshSet(COORDS, ELEMENTS);

[COORDS, ELEMENTS] = meshSet.refine_uniform(0);
meshSet = MeshSet(COORDS, ELEMENTS);

% marker = false(size(ELEMENTS, 1), 1);
% show_marked(meshSet, marker);
% 
% 
% marker([16, 7, 17, 6, 20, 21, 22, 25, 26, 15, 14], 1) = true;
% mark_refine(meshSet, marker);
% show_marked(meshSet, marker);
% 
% 
% [COORDS, ELEMENTS] = refine_marked(meshSet);

% face = meshSet.headFace.Next;
% 
% face8 = face.Next.Next.Next.Next.Next.Next.Next;
% 
% orient = face8.Edges;
% 
% 
% 
% while face.iD ~= -10
%    face.mRef = 0;
%    face = face.Next;
% end



marker = mark_circle([0, 0], 0.5, meshSet);
mark_refine(meshSet, marker);
show_marked(meshSet);


[COORDS, ELEMENTS] = refine_marked(meshSet);
show_marked(meshSet);

% parpool(6)
% 
% parfor i=1:3, c(:, i) = eig(rand(1000)); end
% 
% tic
% n = 200;
% A = 500;
% a = zeros(1,n);
% for i = 1:n
%     a(i) = max(abs(eig(rand(A))));
% end
% toc
% 
% tic
% n = 200;
% A = 500;
% a = zeros(1,n);
% parfor i = 1:n
%     a(i) = max(abs(eig(rand(A))));
% end
% toc
% 
% tic
% ticBytes(gcp);
% n = 200;
% A = 500;
% a = zeros(1,n);
% parfor i = 1:n
%     a(i) = max(abs(eig(rand(A))));
% end
% tocBytes(gcp)
% toc



a = [3, 2, 1];

n = size(a, 2) - 1;

swapped = true;
pos = [1, 2, 3];
fprintf('i : a1 a2 a3\n')

while swapped
   swapped = false;
   for i = 1:n
      if a(i) > a(i+1)
         tmp = a(i);
         a(i) = a(i+1);
         a(i+1) = tmp;
         swapped = true;
         fprintf('%d : ', i)
         fprintf('%d ', a)
         fprintf('\n')
      end
   end
end
















