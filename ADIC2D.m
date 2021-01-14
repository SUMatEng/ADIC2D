function ProcData=ADIC2D(FileNames,Mask,GaussFilt,StepSize,SubSize,SubShape,SFOrder,RefStrat,StopCritVal,WorldCTs,ImgCTs,rho)
	 [~,ImNames]=cellfun(@fileparts,FileNames,'Uni',0);
	 n=numel(FileNames);
	 [r,c]=size(im2double(imread(FileNames{1})));
	 [XosX,XosY]=meshgrid(((SubSize+1)/2+StepSize):StepSize:(c-(SubSize+1)/2-1-StepSize),((SubSize+1)/2+StepSize):StepSize:(r-(SubSize+1)/2-1-StepSize));
	 Xos=[XosX(:)'; XosY(:)'];
	 Xos=Xos(:,arrayfun(@(X,Y) min(min(Mask(Y-(SubSize-1)/2:Y+(SubSize-1)/2,X-(SubSize-1)/2:X+(SubSize-1)/2))),Xos(1,:),Xos(2,:))==1);
	 ProcData=struct('ImgName',ImNames,'ImgSize',repmat({[r,c]},1,n),'ImgFilt',repmat({GaussFilt},1,n),'SubSize',repmat({SubSize*ones([1,size(Xos,2)])},1,n),'SubShape',repmat({repmat(SubShape,size(Xos,2),1)},1,n),'SFOrder',repmat({repmat(SFOrder,size(Xos,2),1)},1,n),'Xos',repmat({Xos},1,n),'P',repmat({zeros([12,size(Xos,2)])},1,n),'C',repmat({ones([1,size(Xos,2)])},1,n),'StopVal',repmat({ones([1,size(Xos,2)])*StopCritVal},1,n),'Iter',repmat({zeros([1,size(Xos,2)])},1,n));
	 ProcData=ImgCorr(n,ProcData,FileNames,RefStrat,StopCritVal); % Section 3.2.1
	 ProcData=CSTrans(n,ProcData,WorldCTs,ImgCTs,rho); % Section 3.3