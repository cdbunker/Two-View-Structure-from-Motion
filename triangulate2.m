function points = triangulate2(pts1,pts2, P1, P2)


  % compute normalizing transform
%   [PPtsHom, tP] = normalise2dpts(pts1);
%   [QPtsHom, tQ] = normalise2dpts(pts2);
%   
%   % 2D cartesian coordinates
%   PPtsCart = PPtsHom(1:2,:);
%   QPtsCart = QPtsHom(1:2,:);
% 
%   % transform cameras
%   P1 = tP * P1;
%   P2 = tQ * P2;
% 
  PPtsCart = pts1(1:2,:);
  QPtsCart = pts2(1:2,:);

  numPts = length(pts1);
  
  % triangulating points
  points = zeros(4,numPts);
  for i = 1:numPts
      A = [
          PPtsCart(1, i) * P1(3, :) - P1(1, :);
          PPtsCart(2, i) * P1(3, :) - P1(2, :);
          QPtsCart(1, i) * P2(3,:) - P2(1,:);
          QPtsCart(2, i) * P2(3,:) - P2(2,:)
      ];

      [~, ~, V] = svd(A);
      points(:, i) = V(:, end);
  end
  for i = 1:4
      points(i, :) = points(i, :) ./ points(4, :);
  end
end

