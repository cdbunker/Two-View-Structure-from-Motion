function plotMatches(I1, I2, fa, fb, matches, num)
%     I(:,:,:,1)=I1/255;
%     I(:,:,:,2)=I2/255;

    figure();
    hold on;
    imshow([I1,I2],[])
    hold on;
    sel = matches(1,1:num) ;
    h1 = vl_plotframe(fa(:,sel)) ;
    h2 = vl_plotframe(fa(:,sel)) ;
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;

    fb_shifted=fb;
    fb_shifted(1,:) = fb_shifted(1,:) + size(I1,2);
    
    sel = matches(2,1:num) ;
    h3 = vl_plotframe(fb_shifted(:,sel)) ;
    h4 = vl_plotframe(fb_shifted(:,sel)) ;
    set(h3,'color','k','linewidth',3) ;
    set(h4,'color','y','linewidth',2) ;
    
    for i=1:num
       x=[fa(1,matches(1,i)),  fb(1,matches(2,i))+size(I1,2)];
       y=[fa(2,matches(1,i)),  fb(2,matches(2,i))];
       line(x,y);
    end
end