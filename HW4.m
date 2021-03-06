%HW4
%% 
%Walter Frank Lenoir
% Problem 1. 
%GB comments:
1a 100
1b 100
1c 100
1d 100 please provide axis information for your plots. Otherwise the plots are meaningless as I do not know which one correlates with mean or std. additionally if you plot multiple graphs like this: 
figure;
plot(1:100,stdmat(1:100));
figure;
plot(1:100,meanmat(1:100));

The second plot overwrites the first and all I see is one plot. To distinguish one from the other you can use 1) subplot function; or 2) write figure(1); plot data figure(2); plot data. In each case two figures will be printed and it will be clear to other users which plot data correlates with the graphs. 
2a 100 I’ll give credit but the nuclear images are really kinda off. Lets talk and see what you did as your answer doesn’t give me the details I need to figure out your issues. 
2b. 75 Close, but the final product is missing both channels in the avi file.  
3a. 100
3b 100
3c 100
3d 100
3e 100
4a. 100
4b. 100
 Overall = 98

% 1. Write a function to generate an 8-bit image of size 1024x1024 with a random value 
% of the intensity in each pixel. Call your image rand8bit.tif. 
img = imggen();

% 2. Write a function that takes an integer value as input and outputs a
% 1024x1024 binary image mask containing 20 circles of that size in random
% locations
N = 10;
mask = circles(N);

% 3. Write a function that takes the image from (1) and the binary mask
% from (2) and returns a vector of mean intensities of each circle (hint: use regionprops).

meanint = meanintensity(img,mask);


% 4. Plot the mean and standard deviation of the values in your output
% vector as a function of circle size. Explain your results. 

for j = 1:100
    tempmask = circles(j);
    meanint = meanintensity(img,tempmask);
    stdmat(j) = std(meanint);
    meanmat(j) = mean(meanint);
end
figure;
plot(1:100,stdmat(1:100));
figure;
plot(1:100,meanmat(1:100));

%With the image created from 1, the image is 8 bit. The mean intensities,
%as the circles became larger stabilizes between 127 and 128 (the middle
%point of 8 bit gray scale points - 0 to 255).Otherwise the mean
%intensities range from 124-130, which is expected (again due to 8 bit
%threshold). Standard deviation limits to 0 which makes sense as
%the larger the circles are, the more area they encompass, suggesting
%overlap and more accurate mean intensities of the overall image. 

%%

%Problem 2.
%Walter Frank Lenoir
%Here is some data showing an NFKB reporter in ovarian cancer cells. 
%https://www.dropbox.com/sh/2dnyzq8800npke8/AABoG3TI6v7yTcL_bOnKTzyja?dl=0
%There are two files, each of which have multiple timepoints, z
%slices and channels. One channel marks the cell nuclei and the other
%contains the reporter which moves into the nucleus when the pathway is
%active. 
%
%Part 1. Use Fiji to import both data files, take maximum intensity
%projections in the z direction, concatentate the files, display both
%channels together with appropriate look up tables, and save the result as
%a movie in .avi format. Put comments in this file explaining the commands
%you used and save your .avi file in your repository (low quality ok for
%space). 

%I first took the max intensity in the z direction by calling zprojection under image/stacks and setting it to max intensity of each image.
%Next I merged the channels of each individual image by calling the merge
%channel function under image/color/merge channels. I then concatenated the image using the concatenate function under
%image/stacks/tools. Finally I used the look up table and used the
%red/green type, as those were the only two colors used in the table. 

%Part 2. Perform the same operations as in part 1 but use MATLAB code. You don't
%need to save the result in your repository, just the code that produces
%it. 

reader1 = bfGetReader('nfkb_movie1.tif');
reader2 = bfGetReader('nfkb_movie2.tif');

reader1.getSizeT % 19
reader2.getSizeT % 18



for i = 1:reader1.getSizeT
    iplane = reader1.getIndex(1-1,1-1,i-1)+1;
    img_max1 = bfGetPlane(reader1,iplane);
    iplane2 = reader1.getIndex(1-1,2-1,i-1)+1;
    img_max2 = bfGetPlane(reader1,iplane2);

    for k = 2:reader1.getSizeZ
        iplane = reader1.getIndex(k-1,1-1,i-1)+1;
        tempimg1 = bfGetPlane(reader1,iplane);
        img_max1 = max(img_max1,tempimg1);
        iplane2 = reader1.getIndex(k-1,2-1,i-1)+1;
        tempimg2 = bfGetPlane(reader1,iplane2);
        img_max2 = max(img_max2,tempimg1);
    end
        
    cattempimg = cat(3,imadjust(img_max1),imadjust(img_max2),zeros(size(tempimg1)));
        
    imwrite(cattempimg,'hw4_2.tif','WriteMode','append')
end


for i = 1:reader2.getSizeT
    iplane = reader2.getIndex(1-1,1-1,i-1)+1;
    img_max1 = bfGetPlane(reader2,iplane);
    iplane2 = reader2.getIndex(1-1,2-1,i-1)+1;
    img_max2 = bfGetPlane(reader2,iplane2);

    for k = 2:reader2.getSizeZ
        iplane = reader2.getIndex(k-1,1-1,i-1)+1;
        tempimg1 = bfGetPlane(reader2,iplane);
        img_max1 = max(img_max1,tempimg1);
        iplane2 = reader2.getIndex(k-1,2-1,i-1)+1;
        tempimg2 = bfGetPlane(reader2,iplane2);
        img_max2 = max(img_max2,tempimg1);
    end
        
    cattempimg = cat(3,imadjust(img_max1),imadjust(img_max2),zeros(size(tempimg1)));
        
    imwrite(cattempimg,'hw4_2.tif','WriteMode','append')
end


reader3 = bfGetReader('hw4_2.tif');


 v = VideoWriter('hw4_2.avi');
 open(v);
 for k=1:reader3.getSizeT  %Tiff is in color, but avi is black and white.
     iplane = reader3.getIndex(1-1,1-1,k-1)+1;
     tempimg1 = bfGetPlane(reader3,iplane);
     tempim = im2double(tempimg1);
     writeVideo(v,tempim);
 end
 close(v);

 
 %%

% Problem 3. 
% Walter Frank Lenoir
% Continue with the data from part 2
% 
% 1. Use your MATLAB code from Problem 2, Part 2  to generate a maximum
% intensity projection image of the first channel of the first time point
% of movie 1. 

reader1 = bfGetReader('nfkb_movie1.tif');

iplane = reader1.getIndex(1-1,1-1,1-1)+1;
img_max1 = bfGetPlane(reader1,iplane);

for k = 2:reader1.getSizeZ
        iplane = reader1.getIndex(k-1,1-1,1-1)+1;
        tempimg1 = bfGetPlane(reader1,iplane);
        img_max1 = max(img_max1,tempimg1);
end

resimg = img_max1;

% 2. Write a function which performs smoothing and background subtraction
% on an image and apply it to the image from (1). Any necessary parameters
% (e.g. smoothing radius) should be inputs to the function. Choose them
% appropriately when calling the function.

imshow(resimg);
imgfil = removebackground(resimg,4,2,100);
imshow(imgfil);

% 3. Write  a function which automatically determines a threshold  and
% thresholds an image to make a binary mask. Apply this to your output
% image from 2. 

mask = automask(imgfil);
imshow(mask);

% 4. Write a function that "cleans up" this binary mask - i.e. no small
% dots, or holes in nuclei. It should line up as closely as possible with
% what you perceive to be the nuclei in your image. 

cleanmask = cleanup(mask,4); %Disk radius
imshow(cleanmask);

% 5. Write a function that uses your image from (2) and your mask from 
% (4) to get a. the number of cells in the image. b. the mean area of the
% cells, and c. the mean intensity of the cells in channel 1.

[cellcount,meanarea,meanintensity] = cellcounts(imgfil,cleanmask);
%55 cells, mean area 168, 1.02e+03 mean intensity

% 6. Apply your function from (2) to make a smoothed, background subtracted
% image from channel 2 that corresponds to the image we have been using
% from channel 1 (that is the max intensity projection from the same time point). Apply your
% function from 5 to get the mean intensity of the cells in this channel.

reader1 = bfGetReader('nfkb_movie1.tif');
iplane = reader1.getIndex(1-1,2-1,1-1)+1;
img_max1 = bfGetPlane(reader1,iplane);

for k = 2:reader1.getSizeZ
        iplane = reader1.getIndex(k-1,2-1,1-1)+1;
        tempimg1 = bfGetPlane(reader1,iplane);
        img_max1 = max(img_max1,tempimg1);
end
imgfil = removebackground(img_max1,4,2,100);

mask = automask(imgfil);

cleanmask = cleanup(mask,4); 

[cellcount,meanarea,meanintensity] = cellcounts(imgfil,cleanmask);
%75 cells, mean area 1345, 507 mean intensity

%%
% Problem 4. 

% 1. Write a loop that calls your functions from Problem 3 to produce binary masks
% for every time point in the two movies. Save a movie of the binary masks.
reader1 = bfGetReader('nfkb_movie1.tif');
reader2 = bfGetReader('nfkb_movie2.tif');


v = VideoWriter('masks.avi');
open(v);

for i = 1:reader1.getSizeT
    iplane = reader1.getIndex(1-1,1-1,i-1)+1;
    img_max1 = bfGetPlane(reader1,iplane);
    
    for k = 2:reader1.getSizeZ
        iplane = reader1.getIndex(k-1,1-1,i-1)+1;
        tempimg1 = bfGetPlane(reader1,iplane);
        img_max1 = max(img_max1,tempimg1);
    end
    
    imgfil = removebackground(img_max1,4,2,100);

    mask = automask(imgfil);

    cleanmask = cleanup(mask,4); 
    
    tempim = im2double(cleanmask);
    writeVideo(v,tempim);
end


for i = 1:reader2.getSizeT 
    iplane = reader2.getIndex(1-1,1-1,i-1)+1;
    img_max1 = bfGetPlane(reader2,iplane);
    
    for k = 2:reader2.getSizeZ
        iplane = reader2.getIndex(k-1,1-1,i-1)+1;
        tempimg1 = bfGetPlane(reader2,iplane);
        img_max1 = max(img_max1,tempimg1);
    end
            
    imgfil = removebackground(img_max1,4,2,100);

    mask = automask(imgfil);

    cleanmask = cleanup(mask,4); 
    
    tempim = im2double(cleanmask);
    writeVideo(v,tempim);
   
end

 close(v);
 
% 2. Use a loop to call your function from problem 3, part 5 on each one of
% these masks and the corresponding images and 
% get the number of cells and the mean intensities in both
% channels as a function of time. Make plots of these with time on the
% x-axis and either number of cells or intensity on the y-axis. 

reader1 = bfGetReader('nfkb_movie1.tif');
reader2 = bfGetReader('nfkb_movie2.tif');


i = 1;
for j = 1:reader1.getSizeT
    iplane = reader1.getIndex(1-1,1-1,j-1)+1;
    img = bfGetPlane(reader1,iplane);
    iplane = reader1.getIndex(1-1,2-1,j-1)+1;
    img2 = bfGetPlane(reader1,iplane);
    
    temp_d = im2double(img);
    imgfil = removebackground(temp_d,4,2,100);
    mask = automask(imgfil);
    cleanmask = cleanup(mask,4);  
    [cellcount1,meanarea1,meanintensity1] = cellcounts(imgfil,cleanmask); 
    
    temp_d = im2double(img2);
    imgfil = removebackground(temp_d,4,2,100);
    mask = automask(imgfil);
    cleanmask = cleanup(mask,4);  
    [cellcount2,meanarea2,meanintensity2] = cellcounts(imgfil,cleanmask);
    
    cells1(1,i) = cellcount1;
    cells1(2,i) = cellcount2;   
    meanint1(1,i) = meanintensity1;
    meanint1(2,i) = meanintensity2;
    i = i+1;
end

for j = 1:reader2.getSizeT
    iplane = reader2.getIndex(1-1,1-1,j-1)+1;
    img = bfGetPlane(reader1,iplane);
    iplane = reader2.getIndex(1-1,2-1,j-1)+1;
    img2 = bfGetPlane(reader2,iplane);
    
    temp_d = im2double(img);
    imgfil = removebackground(temp_d,4,2,100);
    mask = automask(imgfil);
    cleanmask = cleanup(mask,4);  
    [cellcount1,meanarea1,meanintensity1] = cellcounts(imgfil,cleanmask);
    
    temp_d = im2double(img2);
    imgfil = removebackground(temp_d,4,2,100);
    mask = automask(imgfil);
    cleanmask = cleanup(mask,4);  
    [cellcount2,meanarea2,meanintensity2] = cellcounts(imgfil,cleanmask);
    
    cells1(1,i) = cellcount1;
    cells1(2,i) = cellcount2;
    meanint1(1,i) = meanintensity1;
    meanint1(2,i) = meanintensity2;
    i = i+1;
end

figure;

plot(1:i-1,meanint1(1,:));
hold on;
plot(1:i-1,meanint1(2,:));
xlabel('Time');
ylabel('Mean Intensity');

%Channel 1 had more intense cells overall, but varied compared to channel 2 (more consistent
%intensity obeserved in channel 2).

figure;

plot(1:i-1,cells1(1,:));
hold on;
plot(1:i-1,cells1(2,:));

xlabel('Time');
ylabel('Number of Cells');

%Channel 1 had fewer cells detected overall, but was more consistent compared to
%channel 2.

