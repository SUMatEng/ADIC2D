 function [u,v]=PCM(F,G,SubSize,XosX,XosY,SubExtract)
	 NCPS=(fft2(SubExtract(F,[XosX,XosY],SubSize)).*conj(fft2(SubExtract(G,[XosX,XosY],SubSize))))./abs(fft2(SubExtract(F,[XosX,XosY],SubSize)).*conj(fft2(SubExtract(G,[XosX,XosY],SubSize))));
	 CC=abs(ifft2(NCPS));
	 [vid,uid]=find(CC==max(CC(:)));
	 IndShift=-ifftshift(-fix(SubSize/2):ceil(SubSize/2)-1);
	 u=IndShift(uid);
	 v=IndShift(vid);