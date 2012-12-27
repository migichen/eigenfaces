

min_dist=inf;
max_dist=0;
for itr=256:300
    
    
    fname = fname_list{itr}; 
     fname = 'face_pat/i039qa-fn_nonface_cc_s1.jpg';
    
    img = imread(fname);
    img = rgb2gray(img);
    img = imresize(img, [w w]);
    imgmat = reshape(img, w*w, 1);

    dist_ary = recog(imgmat, eigenfaces, w, avgimg, allimg, fname_list);
    min_dist = min(min(dist_ary), min_dist);
    max_dist = max(max(dist_ary), max_dist);
    pause;
end
min_dist
max_dist