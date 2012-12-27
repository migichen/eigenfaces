w = 140;
dirname='face_pat/';
listing = dir(dirname);

imgs = length(listing); % not actual images

% gaussian multiplier
g=gausswin(w,1);
g2=g*g';
g2vec = reshape(g2, w*w, 1);
   

% sum all faces
allimg = zeros(w*w, imgs); % imgs subject to change
allmask = zeros(w,w, imgs);
fname_list = cell(1, length(listing)-3);
count = 0;
for i=1:imgs
    fname = listing(i).name;
    [dum, dum, ext] = fileparts(fname);
    if fname(1)=='.' || strcmp(fname, 'jpg')~=0 ||         fname(6) ~= 'a'
        continue;
    end
    fname = strcat(dirname , fname);

    imgrgb = imread(fname);
    imgrgb = imresize(imgrgb, [w w]);
    img = rgb2gray(imgrgb);
    imgvec = reshape(img, w*w, 1);
    
    % normalize
    imgvec = autocontrast(imgvec);
    
    imgvec = double(imgvec) .* g2vec; % gaussian 
    
    
    count = count+1;
    allimg(:, count) = imgvec;

    fname_list{count} = fname;
    
    % hsv
    imghsv = rgb2hsv(imgrgb);
    allmask(:,:, count) = (imghsv(:,:,1) <= 20/256 | imghsv(:,:,1) >= 240/256) & imghsv(:,:,3) > 10/256 & imghsv(:,:,3)<.95;
    %subplot(1,2,1); imshow(imgrgb); subplot(1,2,2); imshow(allmask(:,:,count), [0 1]);
    
end
allimg(:,count+1:imgs)=[];
allmask(:,:,count+1:imgs) = [];


if count~=size(allimg, 2)
    count
    size(allimg,2)
    return % halt script
end
