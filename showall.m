showw=5;
showh=5;
figure;
for i=1:25
    subplot(5,5,i);
    imshow(reshape(allimg(:,i), [w w]), [0 255]);
end
    