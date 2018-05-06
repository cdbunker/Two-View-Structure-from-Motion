clear all

%run('.\vlfeat-0.9.21\toolbox\vl_setup')

im1Name = strcat(strcat('frame_', num2str(2761)),'.jpg');
I1=imread(im1Name);
I1color=I1;
I1=single(rgb2gray(I1));
[fa, da] = vl_sift(I1, 'PeakThresh', 1);

pics=1;
allMatches=zeros(2,1500,pics-1);
allPoints=zeros(2,5000,pics);
allPoints(:,1:length(fa),1)=fa(1:2,:);

OPTIONS = optimoptions('lsqnonlin', 'Algorithm','levenberg-marquardt', 'Display', 'iter');

im2Name = strcat(strcat('frame_', num2str(2858)),'.jpg');
I2=imread(im2Name);
I2=single(rgb2gray(I2));

[fb, db] = vl_sift(I2, 'PeakThresh', 1);

[matches, scores] = vl_ubcmatch(da, db, 1);
numMatches = length(matches);

j=1;

allMatches(1:2,1:numMatches,j)=matches;
allPoints(:,1:length(fb),j+1)=fb(1:2,:);
matchesPerImage(j) = numMatches;

plotMatches(I1, I2, fa, fb, matches, numMatches);

focal_length_mm = 4.7;
pixel_size_mm = 0.0016;

f_init = focal_length_mm/pixel_size_mm;
K = [f_init/2, 0, size(I1,2)/2; 0, f_init/2, size(I1,1)/2; 0, 0, 1.0000]; %Educated guess

points1=fa(1:2,matches(1,:));
points2=fb(1:2,matches(2,:));

points1H=[points1;ones(1,length(points1))];
points2H=[points2;ones(1,length(points2))];

[F,inliers]=ransac(points1H, points2H);
E = K'*F*K;
% 
% imshow(I1,[])
% hold on;
% sel = matches(1,inliers) ;
% h1 = vl_plotframe(fa(:,sel)) ;
% h2 = vl_plotframe(fa(:,sel)) ;
% set(h1,'color','k','linewidth',3) ;
% set(h2,'color','y','linewidth',2) ;

pts1 = points1H(:,inliers);
pts2 = points2H(:,inliers);

P1 = K*[eye(3), [0,0,0]'];
[R, t] = findP(E, pts1, pts2, P1, K);
P2 = K*[R,t];
points3D = triangulate2(pts1,pts2, P1, P2);
use=find((points3D(3,:)>0)&(points3D(3,:)<150));

scatter3(NaN,NaN,NaN);
hold on;
origPoint = pts1(1:2,use);
for k=1:length(use)
   i=use(k);
   origPointC = origPoint(:,k);
   origPointX = round(origPointC(1));
   origPointY = round(origPointC(2));
   origRGB = I1color(origPointY, origPointX,:);
   scatter3(points3D(1,i), points3D(2,i), points3D(3,i), 'MarkerEdgeColor', double(squeeze(origRGB)')/255, 'MarkerFaceColor', double(squeeze(origRGB)')/255);
end
axis equal
