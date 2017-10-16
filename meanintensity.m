function meanint = meanintensity(img,mask)

measurements = regionprops(mask,img,'MeanIntensity');
meas = struct2dataset(measurements);
meanint = double(meas);
end