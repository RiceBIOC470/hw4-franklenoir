function resimg = removebackground(img,gausx,gausy,diskr)
img_sm = imfilter(img,fspecial('gaussian',gausx,gausy));
img_bg = imopen(img_sm,strel('disk',diskr));
resimg = imsubtract(img_sm,img_bg);
end