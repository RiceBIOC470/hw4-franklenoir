function resmask = automask(img)
thres = mean(prctile(img,90)); %Find an arbitrary threshold at the 90th Percentile
resmask = img > thres;

end