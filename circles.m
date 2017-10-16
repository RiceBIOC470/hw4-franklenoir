function resimg = circles(N)

img = false(1024);
temp1(1,1:20) = randi([1 1024],1,20);
temp1(2,1:20) = randi([1 1024],1,20);

for i = 1:20
    img(temp1(1,i),temp1(2,i)) = true;
end
img_dilate = imdilate(img,strel('disk',N));

resimg = img_dilate;

end
