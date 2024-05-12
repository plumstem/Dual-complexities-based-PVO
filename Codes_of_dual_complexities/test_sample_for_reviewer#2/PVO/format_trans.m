clc;
for i = 1:10
picname1=[num2str(i),'.pgm'];
pathfile1=['..\BOSSbase_1.01\',picname1];
img=imread(pathfile1);
picname2=[num2str(i),'.JPEG'];
pathfile2=['..\JPEG_BOSSbase_1.01\',picname2];
imwrite(img,pathfile2,'JPEG');
end
