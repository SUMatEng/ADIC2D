clear all; close all; clc;

% Images
Sample=3; % which sample to analyse
FileNames=ImageNamesLoad(Sample); % load appropriate images for chosen sample
Mask=ones(size(im2double(imread(FileNames{1})))); % define a mask that includes all pixels of the image

% Function inputs (which set up the DIC analysis)
GaussFilter=[0.4,5];
StepSize=5;
SubSize=41;
SubShape='Circle';
SFOrder=1;
RefStrat=0;
StopCritVal=1e-4;
WorldCTs=0;
ImageCTs=0;
rho=0;

% perform DIC analysis
ProcData=ADIC2D(FileNames,Mask,GaussFilter,StepSize,SubSize,SubShape,SFOrder,RefStrat,StopCritVal,WorldCTs,ImageCTs,rho);

% Correct displacements of incremental reference image strategy so that they describe displacement relative to the first image of the image set
if RefStrat==1
    for d=2:max(size(ProcData))
        ProcData(d).Uw=ProcData(d).Uw+ProcData(d-1).Uw;
    end
end

ProcData=AddGridFormat(ProcData); % add gridded matrices for display purposes
figure
surf(ProcData(4).PosX_grid,ProcData(4).PosY_grid,ProcData(4).DispX_grid) % display displacement in the x direction for the 4th image
xlabel('x')
ylabel('y')
figure
surf(ProcData(4).PosX_grid,ProcData(4).PosY_grid,ProcData(4).DispY_grid) % display displacement in the y direction for the 4th image
xlabel('x')
ylabel('y')

% compute displacement errors depending on the sample analysed
numSubs=size(ProcData(2).Uw,2);
for d=2:max(size(ProcData))
    if (Sample==1)|(Sample==2)
        errorx((d-2)*numSubs+1:(d-1)*numSubs)=ProcData(d).Uw(1,:)'-(d-1)*0.05;
        errory((d-2)*numSubs+1:(d-1)*numSubs)=ProcData(d).Uw(2,:)'+(d-1)*0.05;
    elseif Sample==3
        errorx((d-2)*numSubs+1:(d-1)*numSubs)=ProcData(d).Uw(1,:)'-(d-2)*0.1;
        errory((d-2)*numSubs+1:(d-1)*numSubs)=ProcData(d).Uw(2,:)'-(d-2)*0.1;
    end
end

% compute the mean absolute error
MAEx=nanmean(abs(errorx));
MAEy=nanmean(abs(errory));
% compute the standard deviation of the absolute error
STDx=STD(errorx,MAEx);
STDy=STD(errory,MAEy);
% compute the root mean square error
RMSEx=RMSE_calc(errorx);
RMSEy=RMSE_calc(errory);

% determine magnitude of error metrics
pythag=@(x,y) sqrt(x.^2+y.^2);
bias=pythag(MAEx,MAEy);
variance=pythag(STDx,STDy);
RMSE=pythag(RMSEx,RMSEy);

algorithm={'ADIC2D'};
% display the displacement error metrics in a table
table(algorithm,bias,variance,RMSE)

save('Results.mat','ProcData'); % uncomment this line to save the ProcData results for later use

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Support functions:
function out=STD(errin,maer) % calculate the standard deviation
    total=0;
    count=0;
    err=errin(~isnan(errin));
    for i=1:max(size(err))
        total=total+(abs(err(i))-maer)^2;
        count=count+1;
    end
    out=sqrt(total/(count-1));
end

function out=RMSE_calc(err) % calculate the root mean square error
    count=0;
    total=0;
    for i=1:max(size(err))
        total=total+err(i)^2;
        count=count+1;
    end
    out=sqrt(total/count);
end

function ImName=ImageNamesLoad(Sample) % function to load appropriate images
    ImageLocation=pwd;
    if Sample==1
        ImName{1}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_00.tif');
        ImName{2}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_01.tif');
        ImName{3}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_02.tif');
        ImName{4}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_03.tif');
        ImName{5}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_04.tif');
        ImName{6}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_05.tif');
        ImName{7}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_06.tif');
        ImName{8}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_07.tif');
        ImName{9}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_08.tif');
        ImName{10}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_09.tif');
        ImName{11}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_10.tif');
        ImName{12}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_11.tif');
        ImName{13}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_12.tif');
        ImName{14}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_13.tif');
        ImName{15}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_14.tif');
        ImName{16}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_15.tif');
        ImName{17}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_16.tif');
        ImName{18}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_17.tif');
        ImName{19}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_18.tif');
        ImName{20}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_19.tif');
        ImName{21}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample1/trxy_s2_20.tif');
    elseif Sample==2
        ImName{1}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_00.tif');
        ImName{2}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_01.tif');
        ImName{3}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_02.tif');
        ImName{4}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_03.tif');
        ImName{5}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_04.tif');
        ImName{6}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_05.tif');
        ImName{7}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_06.tif');
        ImName{8}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_07.tif');
        ImName{9}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_08.tif');
        ImName{10}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_09.tif');
        ImName{11}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_10.tif');
        ImName{12}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_11.tif');
        ImName{13}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_12.tif');
        ImName{14}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_13.tif');
        ImName{15}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_14.tif');
        ImName{16}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_15.tif');
        ImName{17}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_16.tif');
        ImName{18}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_17.tif');
        ImName{19}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_18.tif');
        ImName{20}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_19.tif');
        ImName{21}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample2/trs2_b8_20.tif');
    elseif Sample==3
        ImName{1}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3 Reference.tif');
        ImName{2}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3-000 X0.00 Y0.00 N2 C0 R0.tif');
        ImName{3}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3-001 X0.10 Y0.10 N2 C0 R0.tif');
        ImName{4}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3-002 X0.20 Y0.20 N2 C0 R0.tif');
        ImName{5}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3-003 X0.30 Y0.30 N2 C0 R0.tif');
        ImName{6}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3-004 X0.40 Y0.40 N2 C0 R0.tif');
        ImName{7}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3-005 X0.50 Y0.50 N2 C0 R0.tif');
        ImName{8}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3-006 X0.60 Y0.60 N2 C0 R0.tif');
        ImName{9}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3-007 X0.70 Y0.70 N2 C0 R0.tif');
        ImName{10}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3-008 X0.80 Y0.80 N2 C0 R0.tif');
        ImName{11}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3-009 X0.90 Y0.90 N2 C0 R0.tif');
        ImName{12}=fullfile(ImageLocation,'DIC Challenge 1.0/Sample3/Sample3-010 X1.00 Y1.00 N2 C0 R0.tif');
    end
end