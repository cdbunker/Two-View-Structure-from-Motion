function [R, t] = findP(E, pts1, pts2, P, K)
W = [0 -1 0; 1 0 0; 0 0 1];

[U,~,V] = svd(E);

R1 = U*W*V';
R2 = U*W'*V';

t1 = U(:,3);
t2 = -t1;

P1 = [R1, t1];
P2 = [R1, t2];
P3 = [R2, t1];
P4 = [R2, t2];

Pall = zeros(3,4,4);
Pall(:,:,1) = P1;
Pall(:,:,2) = P2;
Pall(:,:,3) = P3;
Pall(:,:,4) = P4;

tri1 = triangulate2(pts1,pts2, P, K*P1);
tri2 = triangulate2(pts1,pts2, P, K*P2);
tri3 = triangulate2(pts1,pts2, P, K*P3);
tri4 = triangulate2(pts1,pts2, P, K*P4);

Tall = zeros(4,length(tri1),4);
Tall(:,:,1) = tri1;
Tall(:,:,2) = tri2;
Tall(:,:,3) = tri3;
Tall(:,:,4) = tri4;

Sall = [];
for i=1:4 %definitely a better way to do this
   Xw = Tall(:,:,i);
    
   Pcurr = Pall(:,:,i);
   Rcurr = Pcurr(:,1:3);
   tcurr = Pcurr(:,4);
   
   V1 = [0,0,1];
   V2 = Rcurr*V1';
   
   inFrontCount=0;
   for j=1:length(Xw)
       d1 = dot(Xw(1:3,j)-tcurr,V1);
       d2 = dot(Xw(1:3,j)-tcurr,V2);
       if (d1>0 && d2>0)
          inFrontCount=inFrontCount+1; 
       end
   end
   
   Sall = [Sall, inFrontCount];
end

[~,ind] = max(Sall);
Puse = Pall(:,:,ind);
%Puse = Pall(:,:,3);
R = Puse(:,1:3);
t = Puse(:,4);

end

