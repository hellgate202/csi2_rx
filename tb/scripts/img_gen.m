clc;
clear all;
close all;

IMG_PATH = './img.jpg';
CSI2_FILE_PATH = './csi2_img.bin';
PX_FILE_PATH = './px_img.bin';
img = double(imread(IMG_PATH));
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);

% Size calculation
x_size = size(img);
y_size = x_size(1);
x_size = x_size(2);

% YCbCr conversion
for y = 1 : 1 : y_size
  for x = 1 : 1 : x_size
    Y(y,x) = uint16((0.299*R(y,x)+0.587*G(y,x)+0.114*B(y,x))*4);
  end
end

% Exapnding size
for y = 1 : 1 : 8
  Y = [Y(1,:); Y ;Y(y_size,:)];
end
y_size = y_size + 16;
for x = 1 : 1 : 8
  Y = [Y(:,1), Y, Y(:,x_size)];
end
x_size = x_size + 16;

f = fopen(CSI2_FILE_PATH, 'wt');
% Packing into CSI2 RAW10
for y = 1 : 1 : y_size
  for x = 1 : 4 : x_size
    byte_1 = dec2bin(Y(y,x),10);
    byte_5 = byte_1(end-1:end);
    byte_1 = byte_1(1:8);
    fprintf(f,'%s\n',byte_1);
    byte_2 = dec2bin(Y(y,x+1),10);
    byte_5 = [byte_2(end-1:end),byte_5];
    byte_2 = byte_2(1:8);
    fprintf(f,'%s\n',byte_2);
    byte_3 = dec2bin(Y(y,x+2),10);
    byte_5 = [byte_3(end-1:end),byte_5];
    byte_3 = byte_3(1:8);
    fprintf(f,'%s\n',byte_3);
    byte_4 = dec2bin(Y(y,x+3),10);
    byte_5 = [byte_4(end-1:end),byte_5];
    byte_4 = byte_4(1:8);
    fprintf(f,'%s\n',byte_4);
    fprintf(f,'%s\n',byte_5);
  end
end

f = fopen(PX_FILE_PATH, 'wt');

for y = 1 : 1 : y_size
  for x = 1 : 1 : x_size
     fprintf(f,'%s\n',dec2bin(Y(y,x)));
  end
end

% for y = 1 : 1 : y_size
%   for x = 1 : 1 : x_size
%     fprintf(mem_file, '%s\n', dec2hex(Y(y,x)));
%   end
% end
