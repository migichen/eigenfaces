fname
    
img = imread(fname);
img = rgb2gray(img);
imgvec = imresize(img, [w w]);
imgvec = reshape(imgvec, w*w, 1);

d =facedetect(imgvec, w, avgimg, eigenfaces);
d
