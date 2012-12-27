% inputs:
% eigenfaces
% in
% w: image width
% avgimg

function dist=recog(img, eigenfaces, w, avgimg, allimg, fname_list)
%fname = 'face_pat/i624ze-fn_nonface_cc_s1.jpg';


    sigma = eigenfaces'*(double(img) - avgimg);


    n= size(allimg,2);
    dist = zeros(1, n);
    for i=1:n
        cur_sigma = eigenfaces'*(allimg(:,i) - avgimg);
        dist(i) = norm( cur_sigma - sigma );
    end

    [Y,I] = min(dist);
    fname_rec = fname_list{I};
    
    [Y,I] = sort(dist);


    subplot(1,7,1);
    img = reshape(img, w,w)
%     img = imread(fname);
    imshow(img);
    title('test image');

    for i=1:6
        fname_rec2 = fname_list{I(i)};
        subplot(1,7,i+1);
        img = imread(fname_rec2);
        imshow(img);
        %title('database image');
        title(fname_rec2);
    end

    Y
end