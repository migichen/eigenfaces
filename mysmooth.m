function out = mysmooth(im, width, sigma)

    g = gausswin(width,sigma);
    g =g/sum(g);
    g2 = g*g';
    %pause
    out = conv2(double(im), g2, 'same');

%     %surf(g2);
%     display_image(out);
end
