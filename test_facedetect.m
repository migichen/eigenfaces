d_ary = zeros(count,1);
for i=1:count
    
    fname = fname_list{i};
    img = imread(fname);
    img = rgb2gray(img);
    imgvec = imresize(img, [w w]);
    imgvec = reshape(imgvec, w*w, 1);
    
    d =facedetect(imgvec, w, avgimg, eigenfaces);
    d_ary(i) = d;
    
end

avg = mean(d_ary)
low = min(d_ary)
high = max(d_ary)