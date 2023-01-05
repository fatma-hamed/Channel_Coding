clear
close all
clc
%video to bits conversion
obj = VideoReader('highway.avi');
a = read(obj);
frames=get(obj,'NumFrames');
for i = 1:frames
    I(i).cdata=a(:,:,:,i);
end
vw1 = VideoWriter('firstVideo.avi','Motion JPEG AVI');
open(vw1);
vw2 = VideoWriter('secondVideo.avi','Motion JPEG AVI');
open(vw2);
vw3 = VideoWriter('thirdVideo.avi','Motion JPEG AVI');
open(vw3);
vw4 = VideoWriter('forthVideo.avi','Motion JPEG AVI');
open(vw4);
vw5 = VideoWriter('fifthVideo.avi','Motion JPEG AVI');
open(vw5);
vw6 = VideoWriter('lastVideo.avi','Motion JPEG AVI');
open(vw6);
for k=1:frames
    s=size(I(k).cdata); 
    movD(1:frames) =struct('cdata', zeros(s(1),s(2), 3, 'uint8'),'colormap', []);
    mov(1:frames) =struct('cdata', zeros(s(1),s(2), 3, 'uint8'),'colormap', []);
    movDInc(1:frames) =struct('cdata', zeros(s(1),s(2), 3, 'uint8'),'colormap', []);
    movD2(1:frames) =struct('cdata', zeros(s(1),s(2), 3, 'uint8'),'colormap', []);
    mov2(1:frames) =struct('cdata', zeros(s(1),s(2), 3, 'uint8'),'colormap', []);
    movDInc2(1:frames) =struct('cdata', zeros(s(1),s(2), 3, 'uint8'),'colormap', []);
    %Red Components of the Frame
    R=I(k).cdata(:,:,1);
%Green Components of the Frame
G=I(k).cdata(:,:,2);
%Blue Components of the Frame
B=I(k).cdata(:,:,3);
R = reshape(R,[1,144*176]);
G = reshape(G,[1,144*176]);
B = reshape(B,[1,144*176]);
Rdouble = double(R);
Gdouble = double(G);
Bdouble = double(B);
Rbin = de2bi(Rdouble);
Gbin = de2bi(Gdouble);
Bbin = de2bi(Bdouble);
Rbin = reshape(Rbin,[1,144*176*8]);
Gbin = reshape(Gbin,[1,144*176*8]);
Bbin = reshape(Bbin,[1,144*176*8]);
ALL_Frame_Bits_old = [Rbin Gbin Bbin];
ALL_Frame_Bits = reshape(ALL_Frame_Bits_old,[608256/1024,1024]);
%Transmission Process
ALL_Frame_Bits_Decoded1 = zeros(144*176*8*3/1024,1024);
ALL_Frame_Bits_NOT_Decoded1 = zeros(144*176*8*3/1024,1024);
ALL_Frame_Bits_Decoded_Inc1 = zeros(144*176*8*3/1024,1024);
ALL_Frame_Bits_Decoded2 = zeros(144*176*8*3/1024,1024);
ALL_Frame_Bits_NOT_Decoded2 = zeros(144*176*8*3/1024,1024);
ALL_Frame_Bits_Decoded_Inc2 = zeros(144*176*8*3/1024,1024);
[rows cul] = size(ALL_Frame_Bits);
punc1 = ones(1,16);
p1=0.001;
p2=0.1;
for j = 1:rows
    packet = ALL_Frame_Bits(j,:);
    %Without coding p = p1
    Notdecoded = bsc(packet,p1);
    ALL_Frame_Bits_NOT_Decoded1(j,:) = Notdecoded;
    %Using 1\2 conv code p = p1
    decoded_half = PacketEncodeDecode(punc1,p1,packet);
    ALL_Frame_Bits_Decoded1(j,:)= decoded_half;
    %Using incremental redundancy p = p1
    [decoded,rate] = PacketEncodeDecodeInc(p1,packet);
    ALL_Frame_Bits_Decoded_Inc1(j,:)= decoded;
    %Without coding p = p2
    Notdecoded2 = bsc(packet,p2);
    ALL_Frame_Bits_NOT_Decoded2(j,:) = Notdecoded2;
    %Using 1\2 conv code p = p2
    decoded_half2 = PacketEncodeDecode(punc1,p2,packet);
    ALL_Frame_Bits_Decoded2(j,:)= decoded_half2;
    %Using incremental redundancy p = p2
    [decoded2,rate2] = PacketEncodeDecodeInc(p2,packet);
    ALL_Frame_Bits_Decoded_Inc2(j,:)= decoded2;
end
    ALL_Frame_Bits_Decoded_New = reshape(ALL_Frame_Bits_Decoded1,[1,144*176*3*8]);
    RD = ALL_Frame_Bits_Decoded_New(1,1:144*176*8);
    GD = ALL_Frame_Bits_Decoded_New(1,144*176*8+1:144*176*8*2);
    BD = ALL_Frame_Bits_Decoded_New(1,144*176*8*2+1:end);
    RD = reshape((uint8(bi2de(reshape(RD,[144*176,8]))')),[144,176]);
    GD = reshape((uint8(bi2de(reshape(GD,[144*176,8]))')),[144,176]);
    BD = reshape((uint8(bi2de(reshape(BD,[144*176,8]))')),[144,176]);
    movD(1,k).cdata(:,:,1) = RD;
    movD(1,k).cdata(:,:,2) = GD;
    movD(1,k).cdata(:,:,3) = BD;
    writeVideo(vw2,movD(1,k));
    ALL_Frame_Bits_NOT_Decoded_New = reshape(ALL_Frame_Bits_NOT_Decoded1,[1,144*176*3*8]);
    RND = ALL_Frame_Bits_NOT_Decoded_New(1,1:144*176*8);
    GND = ALL_Frame_Bits_NOT_Decoded_New(1,144*176*8+1:144*176*8*2);
    BND = ALL_Frame_Bits_NOT_Decoded_New(1,144*176*8*2+1:end);
    RND = reshape((uint8(bi2de(reshape(RND,[144*176,8]))')),[144,176]);
    GND = reshape((uint8(bi2de(reshape(GND,[144*176,8]))')),[144,176]);
    BND = reshape((uint8(bi2de(reshape(BND,[144*176,8]))')),[144,176]);
    mov(1,k).cdata(:,:,1) = RND;
    mov(1,k).cdata(:,:,2) = GND;
    mov(1,k).cdata(:,:,3) = BND;
    writeVideo(vw1,mov(1,k));
    ALL_Frame_Bits_Decoded_Inc_New = reshape(ALL_Frame_Bits_Decoded_Inc1,[1,144*176*3*8]);
    RDI = ALL_Frame_Bits_Decoded_Inc_New(1,1:144*176*8);
    GDI = ALL_Frame_Bits_Decoded_Inc_New(1,144*176*8+1:144*176*8*2);
    BDI = ALL_Frame_Bits_Decoded_Inc_New(1,144*176*8*2+1:end);
    RDI = reshape((uint8(bi2de(reshape(RDI,[144*176,8]))')),[144,176]);
    GDI = reshape((uint8(bi2de(reshape(GDI,[144*176,8]))')),[144,176]);
    BDI = reshape((uint8(bi2de(reshape(BDI,[144*176,8]))')),[144,176]);
    movDInc(1,k).cdata(:,:,1) = RDI;
    movDInc(1,k).cdata(:,:,2) = GDI;
    movDInc(1,k).cdata(:,:,3) = BDI;
    writeVideo(vw3,movDInc(1,k));
    %*****************************for p = 0.1******************************
    ALL_Frame_Bits_Decoded_New2 = reshape(ALL_Frame_Bits_Decoded2,[1,144*176*3*8]);
    RD2 = ALL_Frame_Bits_Decoded_New2(1,1:144*176*8);
    GD2 = ALL_Frame_Bits_Decoded_New2(1,144*176*8+1:144*176*8*2);
    BD2 = ALL_Frame_Bits_Decoded_New2(1,144*176*8*2+1:end);
    RD2 = reshape((uint8(bi2de(reshape(RD2,[144*176,8]))')),[144,176]);
    GD2 = reshape((uint8(bi2de(reshape(GD2,[144*176,8]))')),[144,176]);
    BD2 = reshape((uint8(bi2de(reshape(BD2,[144*176,8]))')),[144,176]);
    movD2(1,k).cdata(:,:,1) = RD2;
    movD2(1,k).cdata(:,:,2) = GD2;
    movD2(1,k).cdata(:,:,3) = BD2;
    writeVideo(vw5,movD2(1,k));
    ALL_Frame_Bits_NOT_Decoded_New2 = reshape(ALL_Frame_Bits_NOT_Decoded2,[1,144*176*3*8]);
    RND2 = ALL_Frame_Bits_NOT_Decoded_New2(1,1:144*176*8);
    GND2 = ALL_Frame_Bits_NOT_Decoded_New2(1,144*176*8+1:144*176*8*2);
    BND2 = ALL_Frame_Bits_NOT_Decoded_New2(1,144*176*8*2+1:end);
    RND2 = reshape((uint8(bi2de(reshape(RND2,[144*176,8]))')),[144,176]);
    GND2 = reshape((uint8(bi2de(reshape(GND2,[144*176,8]))')),[144,176]);
    BND2 = reshape((uint8(bi2de(reshape(BND2,[144*176,8]))')),[144,176]);
    mov2(1,k).cdata(:,:,1) = RND2;
    mov2(1,k).cdata(:,:,2) = GND2;
    mov2(1,k).cdata(:,:,3) = BND2;
    writeVideo(vw4,mov2(1,k));
    ALL_Frame_Bits_Decoded_Inc_New2 = reshape(ALL_Frame_Bits_Decoded_Inc2,[1,144*176*3*8]);
    RDI2 = ALL_Frame_Bits_Decoded_Inc_New2(1,1:144*176*8);
    GDI2 = ALL_Frame_Bits_Decoded_Inc_New2(1,144*176*8+1:144*176*8*2);
    BDI2 = ALL_Frame_Bits_Decoded_Inc_New2(1,144*176*8*2+1:end);
    RDI2 = reshape((uint8(bi2de(reshape(RDI2,[144*176,8]))')),[144,176]);
    GDI2 = reshape((uint8(bi2de(reshape(GDI2,[144*176,8]))')),[144,176]);
    BDI2 = reshape((uint8(bi2de(reshape(BDI2,[144*176,8]))')),[144,176]);
    movDInc2(1,k).cdata(:,:,1) = RDI2;
    movDInc2(1,k).cdata(:,:,2) = GDI2;
    movDInc2(1,k).cdata(:,:,3) = BDI2;
    writeVideo(vw6,movDInc2(1,k));
end
close(vw1);
close(vw2);
close(vw3);
close(vw4);
close(vw5);
close(vw6);
