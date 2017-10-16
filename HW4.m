%HW4
%% 
%Walter Frank Lenoir
% Problem 1. 

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
plot(1:100,stdmat(1:100));
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

zplane = 6;

for i = 1:reader1.getSizeT
    iplane = reader1.getIndex(zplane-1,1-1,i-1)+1;
    tempimg1 = bfGetPlane(reader1,iplane);
    iplane = reader1.getIndex(zplane-1,2-1,i-1)+1;
    tempimg2 = bfGetPlane(reader1,iplane);
    cattempimg = cat(3,imadjust(tempimg1),imadjust(tempimg2),zeros(size(tempimg1)));
        
    temp_d = im2double(cattempimg);
    imgbright = uint16((2^16-1)*(temp_d./max(max(temp_d))));
    
    imwrite(imgbright,'hw4_2.tif','WriteMode','append')
end


for i = 1:reader2.getSizeT 
    iplane = reader2.getIndex(zplane-1,1-1,i-1)+1;
    tempimg1 = bfGetPlane(reader2,iplane);
    iplane = reader2.getIndex(zplane-1,2-1,i-1)+1;
    tempimg2 = bfGetPlane(reader2,iplane);
    cattempimg = cat(3,imadjust(tempimg1),imadjust(tempimg2),zeros(size(tempimg1)));
    
    temp_d = im2double(cattempimg);
    imgbright2 = uint16((2^16-1)*(temp_d./max(max(temp_d))));
    imwrite(imgbright2,'hw4_2.tif','WriteMode','append');
    
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
iplane = reader1.getIndex(6-1,1-1,1-1)+1;
tempimg1 = bfGetPlane(reader1,iplane);

temp_d = im2double(tempimg1);
imgbright = uint16((2^16-1)*(temp_d./max(max(temp_d))));

% 2. Write a function which performs smoothing and background subtraction
% on an image and apply it to the image from (1). Any necessary parameters
% (e.g. smoothing radius) should be inputs to the function. Choose them
% appropriately when calling the function.

imshow(imgbright);
imgfil = removebackground(imgbright,4,2,10);
imshow(imgfil);

% 3. Write  a function which automatically determines a threshold  and
% thresholds an image to make a binary mask. Apply this to your output
% image from 2. 

mask = automask(imgfil);
imshow(mask);

% 4. Write a function that "cleans up" this binary mask - i.e. no small
% dots, or holes in nuclei. It should line up as closely as possible with
% what you perceive to be the nuclei in your image. 

cleanmask = cleanup(mask,3); %Disk radius
imshow(cleanmask);

% 5. Write a function that uses your image from (2) and your mask from 
% (4) to get a. the number of cells in the image. b. the mean area of the
% cells, and c. the mean intensity of the cells in channel 1.

[cellcount,meanarea,meanintensity] = cellcounts(imgfil,cleanmask);
%48 cells, mean area 1549 pixels, 1.09e+04 mean intensity

% 6. Apply your function from (2) to make a smoothed, background subtracted
% image from channel 2 that corresponds to the image we have been using
% from channel 1 (that is the max intensity projection from the same time point). Apply your
% function from 5 to get the mean intensity of the cells in this channel.

reader1 = bfGetReader('nfkb_movie1.tif');
iplane = reader1.getIndex(6-1,2-1,1-1)+1;
tempimg1 = bfGetPlane(reader1,iplane);

temp_d = im2double(tempimg1);
imgbright = uint16((2^16-1)*(temp_d/max(max(temp_d))));
imgfil = removebackground(imgbright,4,2,10);

mask = automask(imgfil);

cleanmask = cleanup(mask,3); 

[cellcount,meanarea,meanintensity] = cellcounts(imgfil,cleanmask);
%51 cells, mean area 869 pixels, 2.45e+03 mean intensity

%%
% Problem 4. 

% 1. Write a loop that calls your functions from Problem 3 to produce binary masks
% for every time point in the two movies. Save a movie of the binary masks.
reader1 = bfGetReader('nfkb_movie1.tif');
reader2 = bfGetReader('nfkb_movie2.tif');

zplane = 6;

v = VideoWriter('masks.avi');
open(v);

for i = 1:reader1.getSizeT
    iplane = reader1.getIndex(zplane-1,1-1,i-1)+1;
    tempimg1 = bfGetPlane(reader1,iplane);
    
    temp_d = im2double(tempimg1);
    imgbright = uint16((2^16-1)*(temp_d./max(max(temp_d))));
    
    imgfil = removebackground(imgbright,4,2,10);

    mask = automask(imgfil);

    cleanmask = cleanup(mask,3); 
    
    tempim = im2double(cleanmask);
    writeVideo(v,tempim);
end


for i = 1:reader2.getSizeT 
    iplane = reader2.getIndex(zplane-1,1-1,i-1)+1;
    tempimg1 = bfGetPlane(reader2,iplane);
    
    temp_d = im2double(tempimg1);
    imgbright = uint16((2^16-1)*(temp_d./max(max(temp_d))));
        
    imgfil = removebackground(imgbright,4,2,10);


    mask = automask(imgfil);

    cleanmask = cleanup(mask,3); 
    
    tempim = im2double(cleanmask);
    writeVideo(v,tempim);
   
end

 close(v);
 
% 2. Use a loop to call your function from problem 3, part 5 on each one of
% these masks and the corresponding images and 
% get the number of cells and the mean intensities in both
% channels as a function of time. Make plots of these with time on the
% x-axis and either number of cells or intensity on the y-axis. 

v = VideoReader('masks.avi');
i = 1;
while hasFrame(v)
    video = readFrame(v);
    channel1 = video(:,:,1); %Channels all read the same. 
    
    temp_d = im2double(channel1);
    imgbright = uint16((2^16-1)*(temp_d./max(max(temp_d))));
    imgfil = removebackground(imgbright,4,2,10);
    mask = automask(imgfil);
    cleanmask = cleanup(mask,3);  
    [cellcount1,meanarea1,meanintensity1] = cellcounts(imgfil,cleanmask);
    
    cells1(1,i) = cellcount1;
    
    meanint1(1,i) = meanintensity1;
    i = i+1;
end

figure;

plot(1:i-1,meanint1(1,:));
xlabel('Time');
ylabel('Mean Intensity');

%Intensity varies low to high. Consistent pattern observed. 

figure;

plot(1:i-1,cells1(1,:));
xlabel('Time');
ylabel('Number of Cells');

%shift due to adding movie 1 & 2 together. Movie 1 has fewer observed cells
%compared to movie 2. 


