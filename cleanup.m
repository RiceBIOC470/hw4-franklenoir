function cleanmask = cleanup(mask,diskr)
imgfi = imfill(mask,'holes');
im_erode = imerode(imgfi,strel('disk',diskr));
im_erode = imdilate(im_erode,strel('disk',diskr)); %
cleanmask = imclose(im_erode,strel('disk',diskr));

end