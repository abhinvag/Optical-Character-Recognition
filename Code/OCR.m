% PRINCIPAL PROGRAM
warning off %#ok<WNOFF>
% Clear all
clc, close all, clear all
% Read image
imagen=imread('TEST_1.JPG');
% Show image
figure(1)
imshow(imagen);
title('INPUT IMAGE WITH NOISE')
%%%%  add noise to the image
%imagen = imnoise(imagen,'gaussian',0,0.05);
% Convert to gray scale
if size(imagen,3)==3 %RGB image
    imagen=rgb2gray(imagen);
end
% Show image
figure(2)
imshow(imagen);
title('INPUT IMAGE GRAYSCALED')
% use median filter
%imagen = medfilt2(imagen,[15 15]);
%figure(3);
%imshow(imagen);
%title('AFTER APPLYING MEDIAN FILTER')
% Convert to BW
threshold = graythresh(imagen);
imagen =~im2bw(imagen,threshold);
title('AFTER THRESHOLDING')
% Show image
figure(4);
imshow(imagen);
% Remove all object containing fewer than 30 pixels
% Opening - Morphological processing
imagen = bwareaopen(imagen,30);
% Show image
figure(5);
imshow(imagen);
title('AFTER MORPHOLOGICAL PROCESSING')
%Storage matrix word from image
word=[ ];
re=imagen;
%Opens text.txt as file for write
fid = fopen('text.txt', 'wt');
% Load templates
load templates
global templates
% Compute the number of letters in template file
num_letras=size(templates,2);
while 1
    %Fcn 'lines' separate lines in text
    [fl re]=lines(re);
    imgn=fl;    
    % Label and count connected components
    [L Ne] = bwlabel(imgn);    
    for n=1:Ne
        [r,c] = find(L==n);
        % Extract letter
        n1=imgn(min(r):max(r),min(c):max(c));  
        % Resize letter (same size of template)
        img_r=imresize(n1,[42 24]);
        % Call fcn to convert image to text
        letter=read_letter(img_r,num_letras);
        % Letter concatenation
        word=[word letter];
    end
    %Write 'word' in text file
    fprintf(fid,'%s\n',word);
    % Clear 'word' variable
    word=[ ];
    %*When the sentences finish, breaks the loop
    if isempty(re) 
        break
    end    
end
fclose(fid);
%Open 'text.txt' file
winopen('text.txt')
clear all