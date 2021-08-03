% pt3 Filter
function [GyroFilt2] = pt3(GyroUnfilt, cutoffHz, sfreqHz)
 
order = 3; 

orderCutoffCorrection = 1/sqrt(2^(1.0 / order) - 1);
cnst = 1 / ( 2 * orderCutoffCorrection * pi * cutoffHz);
filtCutCoeff = sfreqHz / (cnst + sfreqHz);

GyroFilt = 0; % first sample
GyroFilt2 = 0;
GyroFilt3 = 0;
for i = 2 : length(GyroUnfilt)-1
    
    slp = (GyroUnfilt(i) - GyroUnfilt(i - 1));

    GyroFilt(i) = GyroFilt(i - 1) + (filtCutCoeff * slp)
    
    
    GyroFilt(i) = GyroFilt(i) + (filtCutCoeff * (GyroUnfilt(i) - GyroFilt));
    GyroFilt2 = GyroFilt2 + (filtCutCoeff * (GyroFilt - GyroFilt2));
    GyroFilt3 = GyroFilt3 + (filtCutCoeff * (GyroFilt2 - GyroFilt3));
    GyroFilt2(i) = GyroFilt3;
end

% // PT3 Low Pass filter
% 
% float pt3FilterGain(float f_cut, float dT)
% {
%     const float order = 3.0f;
%     const float orderCutoffCorrection = (1 / sqrtf(powf(2, 1.0f / (order)) - 1));
%     float RC = 1 / ( 2 * orderCutoffCorrection * M_PIf * f_cut);
%     // float RC = 1 / ( 2 * 1.961459177f * M_PIf * f_cut);
%     // where 1.961459177 = 1 / sqrt( (2^(1 / order) - 1) ) and order is 3
%     return dT / (RC + dT);
% }
% 
% void pt3FilterInit(pt3Filter_t *filter, float k)
% {
%     filter->state = 0.0f;
%     filter->state1 = 0.0f;
%     filter->state2 = 0.0f;
%     filter->k = k;
% }
% 
% void pt3FilterUpdateCutoff(pt3Filter_t *filter, float k)
% {
%     filter->k = k;
% }
% 
% FAST_CODE float pt3FilterApply(pt3Filter_t *filter, float input)
% {
%     filter->state1 = filter->state1 + filter->k * (input - filter->state1);
%     filter->state2 = filter->state2 + filter->k * (filter->state1 - filter->state2);
%     filter->state = filter->state + filter->k * (filter->state2 - filter->state);
%     return filter->state;
% }