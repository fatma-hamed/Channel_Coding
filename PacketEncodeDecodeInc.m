function [decoded,rate] = PacketEncodeDecodeInc(p,packet)
punc1 = [1 1 1 0 1 0 1 0 0 1 1 0 1 0 1 0];
punc2 = [1 1 1 0 1 0 1 0 1 1 1 0 1 0 1 0];
punc3 = [1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0];
punc4 = [1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0];
punc5 = ones(1,16);
punc = [punc1;punc2;punc3;punc4;punc5];
trellis = poly2trellis(7,[171 133]);
[r,c] = size(punc);
for i = 1:r
    encoded=convenc( packet, trellis,punc(i,:));
    Errored=bsc(encoded,p);
    if i ==1
        punci = punc1;
        rate = 8/9;
    elseif i ==2 
        punci = punc2;
        rate = 4/5;
    elseif i ==3
        punci = punc3;
        rate = 2/3;
    elseif i ==4
        punci = punc4;
        rate = 4/7;
    else 
        punci = punc5;
        rate = 1/2;
    end
    decoded=vitdec(Errored,trellis,35,'trunc','hard',punci);
    if packet==decoded
        break;
    end
end
end
