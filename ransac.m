function [F, inliers] = ransac(pts1,pts2)
%RANSAC for Fundamental Matrix
%x'*F*x_p < thr -> inlier

nums=1:length(pts1);
bestInliers = [];

for it = 1:30000 %probably a better way to do this
    if (length(bestInliers) == length(pts1))
       continue 
    end
    sample = datasample(nums,8,'Replace', false);
    F = findFundamental(pts1(:,sample), pts2(:,sample));

    currInliers = findInliers(F, pts1, pts2);
    if (length(currInliers) > length(bestInliers))
        bestInliers = currInliers;
    end
    if (mod(it,500)==0)
        fprintf('Iteration: %i\tBest Inlier Count: %i\n', it, length(bestInliers));
    end
end

F = findFundamental(pts1(:,bestInliers), pts2(:,bestInliers));

inliers = bestInliers;
end

function inliers = findInliers(F, pts1,pts2)
inliers = [];

% for i = 1:length(pts1)
% %     if (abs(d) < 0.1)
% %        inliers = [inliers,i]; 
% %     end
% end

    d = computeDistance(pts1, pts2, F);
    inliers = find(d < 0.1);
end

function d = computeDistance(pts1h, pts2h, f)
pfp = (pts2h' * f)';
pfp = pfp .* pts1h;
d = sum(pfp, 1) .^ 2;

epl1 = f * pts1h;
epl2 = f' * pts2h;
d = d ./ (epl1(1,:).^2 + epl1(2,:).^2 + epl2(1,:).^2 + epl2(2,:).^2);
end