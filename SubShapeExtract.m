 function [f,dfdx,dfdy,dX,dY]=SubShapeExtract(SubSize,SubShape,Xos,F,dFdx,dFdy,SubExtract)
	 switch SubShape
	 case 'Square'
		 f(:)=reshape(SubExtract(F,Xos,SubSize),[SubSize*SubSize,1]);
		 dfdx(:)=reshape(SubExtract(dFdx,Xos,SubSize), [SubSize*SubSize,1]);
		 dfdy(:)=reshape(SubExtract(dFdy,Xos,SubSize), [SubSize*SubSize,1]);
		 [dX,dY]=meshgrid(-(SubSize-1)/2:(SubSize-1)/2, -(SubSize-1)/2:(SubSize-1)/2); dX=dX(:); dY=dY(:);
	 case 'Circle'
		 f=SubExtract(F,Xos,SubSize);
		 dfdx=SubExtract(dFdx,Xos,SubSize);
		 dfdy=SubExtract(dFdy,Xos,SubSize);
		 [dX,dY]=meshgrid(-(SubSize-1)/2:(SubSize-1)/2,-(SubSize-1)/2:(SubSize-1)/2); % THIS LINE IS WRONG IN ARTICLE
		 mask_keep=sqrt(abs(dX).^2+abs(dY).^2)<=(SubSize/2-0.5);
		 f=f(mask_keep);
		 dfdx=dfdx(mask_keep); dfdy=dfdy(mask_keep);
		 dX=dX(mask_keep); dY=dY(mask_keep);
	 end