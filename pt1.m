function [GyroFilt] = pt1(GyroUnfilt, cutoffHz, samplingfreqHz, order)
% [GyroFilt] = pt1(GyroUnfilt, cutoffHz, samplingfreqHz, order)

if order<1 || order >3,
    disp('choose 1-3 only, for 1st 2nd or 3rd order filter only')
else
    
    filtCut=((2*pi)*cutoffHz)/samplingfreqHz;
    GyroFilt=0;%place 0 in first filtered sample

    for i=2:length(GyroUnfilt)
        if order>0 
            GyroFilt(i)=GyroFilt(i-1) + (filtCut * (GyroUnfilt(i) - GyroFilt(i-1)));%1st order 
        end
        if order>1 
            GyroFilt(i)=GyroFilt(i-1) + (filtCut * (GyroFilt(i) - GyroFilt(i-1)));% 2nd order cascade
        end
        if order>2 
            GyroFilt(i)=GyroFilt(i-1) + (filtCut * (GyroFilt(i) - GyroFilt(i-1)));% 3nd order cascade
        end
    end
end

 

