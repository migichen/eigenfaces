%% search and mark faces
% global input: 
%   w as eigenfaces image width
%   fname: image filename 

% scale the input image.  The testing window is fixed to w*w
scale_cells = { .7, .8, .9, 1 };%, 1.3, 1.5};%, 1.7, 1.9 };%.2, .4, .6
scale_cells = { 1.7, 1.8, 1.9, 2, 2.1 };%2.4, 2.6};%, 1.7, 1.9 };%.2, .4, .6

scan_interval = floor(w/8);  % first quick search
scan_interval2 = w/10;  % refine search
th_skin = 0.5; % percentage of skin color should appear in the window

fname

subplot(1,1,1);

imgrgb = imread(fname);
imshow(imgrgb);
imghsv = rgb2hsv(imgrgb);
% skin detect
imgmask = (imghsv(:,:,1) <= 20/256 | imghsv(:,:,1) >= 240/256) & imghsv(:,:,3) > 10/256 & imghsv(:,:,3)<.95 & imghsv(:,:,2)>.1;
img = rgb2gray(imgrgb);

% test
% s=size(imgmask);
% imgmask = ones(s(1), s(2));
     
% result
result_d=[];
result_range=[];
result_mean=[];
results=0;

for scale = scale_cells

    imgr = imresize(img, scale{1});
%     imshow(imgr);
    
    imgmaskr = imresize(imgmask, scale{1});
    
    
    imgsize = size(imgr);
    if imgsize(1)<w || imgsize(2)<w
        continue
    end
    
    disp('first loop')
    for y=1:scan_interval:imgsize(1)-w
        for x=1:scan_interval:imgsize(2)-w
            subimg = imgr(y:y+w-1, x:x+w-1);
            subimgmask = imgmaskr(y:y+w-1, x:x+w-1);
            if (sum(sum(subimgmask)) / (w*w) < th_skin)
                continue;
            end
            

            subimg = mysmooth(subimg, 10, 1);
            imgvec = reshape(subimg, w*w, 1);
            imgvec = double(imgvec).*g2vec; % gaussian 
            %normalize
            imgvec = autocontrast(imgvec); % auto contrast the lighting
            

            d =facedetect(imgvec, w, avgimg, eigenfaces);
            

            % Here the threshold for determining face or non-face.
            % Use test_facedetect to determine the value
            %              isface = d<4000;
            isface = d<3000; % R=10
            %                 isface = d<3000;
            isface=d<5500;
            %             imshow(imgr);

            if isface
                rectangle('position',[x/scale{1} y/scale{1} w/scale{1} w/scale{1} ], 'EdgeColor','y', 'LineWidth',2)
                
                out_y=y;
                out_x=x;
                out_imgvec = imgvec;
                disp('face found. second loop')
                if 1
                    for itr = 1:100
                        out_y=y;
                        out_x=x;
                        for yy = y-2 : 2 : y+2
                            for xx = x-2: 2 : x+2
                                if yy<1 || yy>imgsize(1)-w || xx<1 || xx>imgsize(2)-w
                                    continue;
                                end
                                subimg = imgr(yy:yy+w-1, xx:xx+w-1);

                                imgvec = reshape(subimg, w*w, 1);
                                imgvec = double(imgvec).*g2vec; % gaussian 
            %normalize
            imgvec = imgvec - mean(imgvec);

                            
                                dd = facedetect(imgvec, w, avgimg, eigenfaces);
                                if dd<d
                                    d = dd;
                                    out_y = yy;
                                    out_x = xx;
                                    out_imgvec=imgvec;
                                end
                            end
                        end
                        if out_y==y && out_x==x
                            break;
                        end
                        x=out_x;
                        y=out_y;
                    end
                else
                    for yy = uint32( max(1,y-scan_interval/2) : scan_interval2 : min(y+(scan_interval/2)-1, imgsize(1)-w) )
                        for xx = uint32( max(1, x-scan_interval/2) : scan_interval2 : min(x+scan_interval/2-1, imgsize(2)-w) )
                            subimg = imgr(yy:yy+w-1, xx:xx+w-1);

                            imgvec = reshape(subimg, w*w, 1);
                            imgvec = double(imgvec).*g2vec; % gaussian 

                            dd = facedetect(imgvec, w, avgimg, eigenfaces);
                            if dd<d
                                d = dd;
                                out_y = yy;
                                out_x = xx;
                                out_imgvec=imgvec;
                            end
                        end
                    end
                end
                d
                if (d<5500)
                    results = results+1;
                    result_d(results)=d;
                    result_range{results} =  [out_x/scale{1} out_y/scale{1} w/scale{1} w/scale{1} ];
                    result_mean(:,results) =  [(out_x+w/2)/scale{1}; (out_y+w/2)/scale{1}];

                    rectangle('position',[out_x/scale{1} out_y/scale{1} w/scale{1} w/scale{1} ], 'EdgeColor','g', 'LineWidth',2)
                end
%                  pause
%             	recog(out_imgvec, eigenfaces, w, avgimg, allimg, fname_list);
%                 pause
pause(.1)
                % save result
                
            else
                  rectangle('position',[x/scale{1} y/scale{1} w/scale{1} w/scale{1}], 'EdgeColor','r', 'LineWidth',1)
            end
        end
       
    end
    disp('press key...')
    pause
end

th_d = 100;

[Y I]=sort(result_d);
result_on=zeros(results,1);
for i=1:results
    if i==1
        result_on(i)=1;
        continue
    end
    d_ary=zeros(1,i-1);
    for j=1:i-1
        if result_on(j)
            d_ary(j) = norm(result_mean(:,I(i))- result_mean(:,I(j)));
        else
            d_ary(j) = 1e+8;
        end
    end
    min_d = min(d_ary);
    result_on(i) = (min_d > th_d);
    
end

%% extract faces and save into file
figure;
imshow(imgrgb);
for i=1:results
    if result_on(i)
        result_d(I(i))
        range = result_range{I(i)};
        rectangle('position',[range(1) range(2) range(3) range(4) ], 'EdgeColor','g', 'LineWidth',2)
        [range(1) range(2) range(3) range(4) ]
        
        if (sum(result_on)<5)
            subimg = imgrgb(uint32(range(2)):uint32(min(imgsize(1), range(2)+range(4)-1)), uint32(range(1)):uint32(min(imgsize(2), range(1)+range(3)-1)), :);
            subimg = imresize(subimg, w/range(3)); % resize to w
            imwrite(subimg, sprintf('face_%d.jpg', i));
        end
    end
end