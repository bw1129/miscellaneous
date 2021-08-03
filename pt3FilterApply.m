% pt3 Filter
function [GyroFilt] = pt1(GyroUnfilt, cutoffHz, sfreqHz)
 
order = 3; 

orderCutoffCorrection = 1/sqrt(2^(1.0 / order) - 1);
cnst = 1 / ( 2 * orderCutoffCorrection * pi * cutoffHz);
filtCutCoeff = sfreqHz / (cnst + sfreqHz);

GyroFilt = 0; % first sample

for i = 2 : length(GyroUnfilt)
    
    slp = (GyroUnfilt(i) - GyroFilt(i - 1));

    GyroFilt(i) = GyroFilt(i - 1) + (filtCutCoeff * slp);
    
   % disp(['coeff: ' num2str(filtCut) ', slp: ' num2str(slp) ', old-new: ' num2str(GyroUnfilt(i)-GyroFilt(i))])
   % pause(1);
    
end
