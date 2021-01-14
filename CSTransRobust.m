function PD=CSTransRobust(n,PD,WorldCTs,ImgCTs,rho)
	if WorldCTs~=0 | ImgCTs~=0
		CamParams=estimateCameraParameters(ImgCTs,WorldCTs); % Section 2.1.4
	else
		CamParams=cameraParameters('ImageSize',PD(1).ImgSize,'IntrinsicMatrix',eye(3),'WorldPoints',PD(1).Xos','RotationVectors',[0,0,0],'TranslationVectors',[0,0,0]);
		WorldCTs=PD(1).Xos'; ImgCTs=PD(1).Xos';
	end
	[R,T]=extrinsics(ImgCTs(:,:,end),WorldCTs,CamParams);
	Tspec=T-[0,0,rho]*R; % Equation (6)
	for d=1:n
		Xds(1,:)=PD(d).Xos(1,:)+PD(d).P(1,:); % Equation (24)
		Xds(2,:)=PD(d).Xos(2,:)+PD(d).P(7,:); % Equation (24)
		indValid=find((isnan(Xds(1,:))+isnan(Xds(2,:)))==0); % determine indices of invalid subsets so that they are not analysed (which causes code to crash)
		PD(d).Xow(:,indValid)=pointsToWorld(CamParams,R,Tspec, undistortPoints(PD(d).Xos(:,indValid)',CamParams))';
		Xdw(:,indValid)=pointsToWorld(CamParams,R,Tspec, undistortPoints(Xds(:,indValid)',CamParams))';  
		PD(d).Uw=Xdw-PD(d).Xow; % Equation (26)
		PD(d).CamParams=CamParams;
	end