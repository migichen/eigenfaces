
function d=facedetect(imgvec, w, avgimg, eigenfaces)

    diffimg = double(imgvec) - avgimg;
    dist = diffimg - eigenfaces*(eigenfaces'*diffimg);
    d = norm(dist);
    
%     g=figure;
%     subplot(1,2,2)
%     imshow(reshape(abs(dist), [w w]), [0 128])
%     subplot(1,2,1)
%     imshow(reshape(imgvec, [w w]), [0 255])
%     title(d)
%     pause
%     close(g)
    
    
    % normalize
    %d = d / norm(imgvec);
    
end 