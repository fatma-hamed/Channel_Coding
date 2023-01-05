clear
close all
clc
k = 1;
%video to bits conversion
obj = VideoReader('highway.avi');
a = read(obj);
frames=get(obj,'NumFrames');
for i = 1:frames
    I(i).cdata=a(:,:,:,i);
end
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
ALL_Frame_Bits_Decoded1 = zeros(144*176*8*3/1024,1024);
ALL_Frame_Bits_NOT_Decoded1 = zeros(144*176*8*3/1024,1024);
ALL_Frame_Bits_Decoded_Inc1 = zeros(144*176*8*3/1024,1024);
[rows cul] = size(ALL_Frame_Bits);
punc1 = ones(1,16);
for p = 0.0001:0.01:0.2
    E_half =0;
    E_Inc =0;
    throughput =0;
for j = 1:rows
    packet = ALL_Frame_Bits(j,:);
    %Using 1\2 conv code 
    decoded_half = PacketEncodeDecode(punc1,p,packet);
    ALL_Frame_Bits_Decoded1(j,:)= decoded_half;
    E_half = E_half+ sum(xor(packet,decoded_half))/length(packet);
    %Using incremental redundancy 
    [decoded,rate] = PacketEncodeDecodeInc(p,packet);
    ALL_Frame_Bits_Decoded_Inc1(j,:)= decoded;
    E_Inc = E_Inc + sum(xor(packet,decoded))/length(packet);
    throughput = throughput +length(packet)/rate;
end
E_half_total((p-0.0001)*100+1) = E_half/rows;
E_Inc_total((p-0.0001)*100+1) = E_Inc/rows;
throughput_total((p-0.0001)*100+1) = throughput/rows;
end
p = [0.0001:0.01:0.2];
figure(1)
plot(p,E_half_total)
figure(2)
plot(p,E_Inc_total)
figure(3)
plot(p,throughput_total)


