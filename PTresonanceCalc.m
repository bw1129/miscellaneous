function [AmpSpec, freq, segment_vector, segment_length] = PTresonanceCalc(Sin, lograte, subsampleFactor)
%% [AmpSpec, freq, segment_vector, segment_length] = PTresonanceCalc2(Sin, lograte))

% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

segment_length = (lograte*1000); % 1 sec segments
%subsampleFactor=10;% moving window steps at 1/10th intervals of segment_length

segment_vector=1:round(segment_length/subsampleFactor):length(Sin);
NSegs=max(find((segment_vector+segment_length) < segment_vector(end)));
if NSegs>0
    Sinseg=[]; Soutseg=[];
    j=0;
    for i=1:NSegs
        j=j+1;
        Sinseg(j,:)=Sin(segment_vector(i):segment_vector(i)+segment_length-1);  
    end

    clear resp resp2 G H Hcon imp impf a b resptmp AmpSpec Spad Shamm
    padLength = 500;
    totalLength = (segment_length+(padLength * 2));
    maxFreq = (segment_length * .5) + (padLength * 2); % Nyquist  
    freq = maxFreq/totalLength : maxFreq/totalLength : maxFreq;
    j=0;
    if ~isempty(Sinseg)
        for i=1:size(Sinseg,1)
            Shamm = Sinseg(i,:).*hann(length(Sinseg(i,:)))';% hann goes right to 0 on both ends, hamming not
            Spad = [zeros(1,padLength) Shamm zeros(1,padLength)];
            a=fft(Spad);% input, use hann or hamming taper
            G=real(a)/length(a);
            j=j+1;
            AmpSpec(j,:)=abs(G(:,1:length(freq)));
        end 
    end
end

end
