function [decoded] = PacketEncodeDecode(punc1,p,packet)
trellis = poly2trellis(7,[171 133]); 
encoded=convenc( packet, trellis,punc1);
Errored=bsc(encoded,p);
decoded=vitdec(Errored,trellis,35,'trunc','hard',punc1);
end


