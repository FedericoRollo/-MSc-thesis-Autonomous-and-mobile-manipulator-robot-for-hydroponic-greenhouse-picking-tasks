%clear all the variables and figures 
clc; clear all; close all;
%Load the image for the segmantation
zucc = imread('zucchiniapproachedRED.jpg');% imshow(zucc);

%move the image from the RGB space to the CIE XYZ (Lab) one and extract the
%color plane
xyz_zucc = rgb2lab(zucc);
xz = xyz_zucc(:,:,2:3);
xz = im2single(xz);

% number of different colors to be extracted. It characterize the number of
% the final clusters
n_Clusters = 4;

%k-mean segmantation
pixel_labels = imsegkmeans(xz,n_Clusters,'NumAttempt',3);

%shows the clusters labelled with different grays colors
figure
imshow(pixel_labels,[]) 

%use different masks to extract form the original image the clusters found.
mask1 = pixel_labels==1;
cluster1 = zucc .* uint8(mask1);
figure
imshow(cluster1)

mask2 = pixel_labels==2;
cluster2 = zucc .* uint8(mask2);
figure
% imshow(cluster2)

mask3 = pixel_labels==3;
cluster3 = zucc .* uint8(mask3);
figure
imshow(cluster3)

mask4 = pixel_labels==4;
cluster4 = zucc .* uint8(mask4);
figure
imshow(cluster4)

% mask5 = pixel_labels==5;
% cluster5 = zucc .* uint8(mask5);
% figure
% imshow(cluster5)

% try to identify the various flowers.. 

%binarizzazione dell'immagine
grayIm = rgb2gray(cluster3);
bw = imbinarize(grayIm);
figure
imshow(bw)

%noise attenuation
bw = bwareaopen(bw,10);
figure;
imshow(bw);

%NOT STREACTLY NEEDED IN SOME CASES. IT COULD BE USEFUL IF YOU WANT TO CLOSE
%SOME BOUNDARIES IN AN IMAGE FOR EXAMPLE IF YOU WANT TO CLOSE A CIRCLE AREA
%WHICH IN THE BINARIZATION OF THE IMAGE RESULTS OPEN YOU USE THIS AND THENO
%YOU FILL THE WHOLE ARE WITH THE NEXT INSTRUCTIONS BLOCK. TO USE THIS
%CHANGE THE 0 VALUE OF STREL INSTRUCTION.
%fill the holes in the image by finding circles in it
se = strel('disk',0);
bw = imclose(bw,se);
figure
imshow(bw)

%fill all the closed boundaries
bw = imfill(bw,'holes');
figure;
imshow(bw);

%find the boundaries of the non empty figures (B boundary funtion, L
%labeled image
[B,L] = bwboundaries(bw,'noholes');

% plot the image with coulours and highlight the boundaries
figure
imshow(label2rgb(L,@jet,[.5 .5 .5]))
hold on
for k = 1:length(B)
  boundary = B{k};
  plot(boundary(:,2),boundary(:,1),'w','LineWidth',1)
end

%extract the centroids from the labeled image and plot on the previous
%image
s = regionprops(L,'centroid');
centroids = cat(1,s.Centroid);
plot(centroids(:,1),centroids(:,2),'r*')

% number of flower present in the image
Numberflowers = length(centroids);

%print of the original flower divided with the respective centroids.
for i = 1:k
    clust = L==i;
    cluster = zucc .* uint8(clust);
    figure
    imshow(cluster);
    hold on
    plot(centroids(i,1),centroids(i,2),'b*')
end
