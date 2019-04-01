clc;
clear all;
close all;
IMG_FILE_PATH = '../rx_img.bin';
X_RES = 1936;
Y_RES = 1096;

f = fopen(IMG_FILE_PATH, 'rt');
for y = 1 : 1 : Y_RES
  for x = 1 : 1 : X_RES
    img(y,x) = uint8(str2num(fgetl(f))/4);
  end
end

imshow(img);
