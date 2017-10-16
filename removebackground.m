function resimg = removebackground(img,gausx,gausy,diskr)
img_sm = imfilter(img,fspecial('gaussian',gausx,gausy));
resimg = imopen(img_sm,strel('disk',diskr));
end