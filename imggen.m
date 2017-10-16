function img = imggen
r = randi([0 255],1024,1024);
r = uint8(r);
imwrite(r,'rand8bit.tif')
img = r;
end