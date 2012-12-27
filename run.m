R=5 % PCA 


avgimg = mean(allimg')';

% test
img = reshape(avgimg, w ,w);
imshow(img, [-128 128])

% diff method 1
%diffmat = allimg - avgimg*ones(1, count);
% diff method 2
diffmat = allimg;
for i=1:size(allimg,2)
    diffmat(:,i) = diffmat(:,i)-avgimg;
end

% correlation
% C = diffmat*diffmat';
% [U,S,V] = svd(C);
L = diffmat'*diffmat;
%[U,S,V] = svd(L);
[V,D] = eigs(L, R); % get R largest eigenvalues
eigenfaces = diffmat*V;

% normalize method 1
D = D(D~=0);
eigenfaces = eigenfaces * diag( D.^(-.5) );

% remove the first one
%  eigenfaces(:,1)=[];
 

%normalize method 2 (same result)
% n=R; %n=size(eigenfaces,2);
% for i=1:n
%     norm_val = norm(eigenfaces(:,i),2);
%     eigenfaces(:,i) = eigenfaces(:,i) / norm_val;
% end


%show
figure;
subplot(2,5,1);
imshow(reshape(eigenfaces(:,1)*2560+avgimg,w,w), [0 255]);
subplot(2,5,2);
imshow(reshape(eigenfaces(:,2)*2560+avgimg,w,w), [0 255]);
subplot(2,5,3);
imshow(reshape(eigenfaces(:,3)*2560+avgimg,w,w), [0 255]);
subplot(2,5,4);
imshow(reshape(eigenfaces(:,4)*2560+avgimg,w,w), [0 255]);
subplot(2,5,5);
imshow(reshape(eigenfaces(:,5)*2560+avgimg,w,w), [0 255]);
subplot(2,5,6);
imshow(reshape(eigenfaces(:,6)*2560+avgimg,w,w), [0 255]);
subplot(2,5,7);
imshow(reshape(eigenfaces(:,7)*2560+avgimg,w,w), [0 255]);
subplot(2,5,8);
imshow(reshape(eigenfaces(:,8)*2560+avgimg,w,w), [0 255]);
title('highest 8 eigenfaces');

%% skin color
face_percent_avg=0;
face_percent_min=1;
for i=1:size(allmask, 3)
    p = sum(sum(allmask(:,:,i))) / (w*w);
    face_percent_avg = face_percent_avg + p;
    face_percent_min = min(face_percent_min , p);
   
end
face_percent_avg = face_percent_avg / size(allmask, 3);

disp('done')
% output: eigenfaces with length=R