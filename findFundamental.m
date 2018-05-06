function F = findFundamental(p1, p2)

[p1Norm, T1] = normalise2dpts(p1);
[p2Norm, T2] = normalise2dpts(p2);

p1Norm=p1Norm';
p2Norm=p2Norm';

X = [p1Norm(:,1).*p2Norm(:,1), p1Norm(:,1).*p2Norm(:,2), ...
    p1Norm(:,1),               p1Norm(:,2).*p2Norm(:,1), ...
    p1Norm(:,2).*p2Norm(:,2),  p1Norm(:,2),              ...
    p2Norm(:,1),               p2Norm(:,2)];

X = [X, ones(size(X,1),1)];

[~, ~, V] = svd(X);

F = V(:,9);
F;
F = reshape(F, 3, 3);

[U, D, V] = svd(F);
D(3,3) = 0;
F = U*D*V';

F = T2'*F*T1;
F=F/sign(F(3,3));
F=F/norm(F);
end
