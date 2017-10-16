function cleanmask = cleanup(mask,diskr)
im_erode = imerode(mask,strel('disk',diskr)); %seperate cells that are close together
%get ride of noise
im_close = imclose(im_erode,strel('disk',diskr)); %close up holes
cleanmask = imfill(im_close,'holes');
end