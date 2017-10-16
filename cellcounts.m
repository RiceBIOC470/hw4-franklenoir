function [cellcount,meanarea,meanintensity] = cellcounts(imgfil,cleanmask)
measurements = regionprops( cleanmask,imgfil, 'MeanIntensity','FilledArea');
cellcount = length(measurements);

meanints(1:cellcount) = measurements(1:cellcount).MeanIntensity;
meanintensity = mean(meanints);

meanfil(1:cellcount) = measurements(1:cellcount).FilledArea;
meanarea = mean(meanfil);
end