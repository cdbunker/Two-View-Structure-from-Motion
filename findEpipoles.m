function [e0,e1] = findEpipoles(F)
[U,~,V] = svd(F);

e1 = U(:,3);
e1 = e1/e1(3);

e0 = V(:,3);
e0 = e0/e0(3);

end

