function PD=AddGridFormat(PD)
	for d=1:size(PD,2)
		% determine vectors to relate the subset position (in pixels in the distorted sensor CS) to its position within the grid matrices
		XindicesUnique=sort(ceil(unique(PD(d).Xos(1,:))));
		Xindices=NaN(1,XindicesUnique(end));
		Xindices(XindicesUnique)=1:1:size(XindicesUnique,2);
		YindicesUnique=sort(ceil(unique(PD(d).Xos(2,:))));
		Yindices=NaN(1,YindicesUnique(end));
		Yindices(YindicesUnique)=1:1:size(YindicesUnique,2);
		% convert the data to the format of grid matrices
		for q=1:size(PD(d).Xow,2)
			PD(d).PosX_grid(Yindices(ceil(PD(d).Xos(2,q))),Xindices(ceil(PD(d).Xos(1,q))))=PD(d).Xow(1,q); % grid matrix for the x-position of the subset in the world CS
			PD(d).PosY_grid(Yindices(ceil(PD(d).Xos(2,q))),Xindices(ceil(PD(d).Xos(1,q))))=PD(d).Xow(2,q); % grid matrix for the y-position of the subset in the world CS
			PD(d).DispX_grid(Yindices(ceil(PD(d).Xos(2,q))),Xindices(ceil(PD(d).Xos(1,q))))=PD(d).Uw(1,q); % grid matrix for the x-displacement in the world CS
			PD(d).DispY_grid(Yindices(ceil(PD(d).Xos(2,q))),Xindices(ceil(PD(d).Xos(1,q))))=PD(d).Uw(2,q); % grid matrix for the y-displacement in the world CS
			CheckElements(Yindices(ceil(PD(d).Xos(2,q))),Xindices(ceil(PD(d).Xos(1,q))))=PD(d).Xos(1,q); % determine grid matrix of the x-position of the subset in the distorted sensor CS (used to identify grid matrix positions that do not have a corresponding subset that was analysed by ADIC2D)
		end
		% set the values of the elements of the grid matrices, that do not correspond to an analysed subset, to NaN (such that they are not displayed)
		[r,c]=size(PD(d).PosX_grid);
		for i=1:r
			for j=1:c
				if CheckElements(i,j)==0
					PD(d).PosX_grid(i,j)=NaN;
					PD(d).PosY_grid(i,j)=NaN;
					PD(d).DispX_grid(i,j)=NaN;
					PD(d).DispY_grid(i,j)=NaN;
				end
			end
		end
	end
end