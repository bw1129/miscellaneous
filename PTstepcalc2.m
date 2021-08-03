function [stepresponse, t, segment_vector, segment_length] = PTstepcalc2(Sin, Sout, lograte)
%% [stepresponse, t] = PTstepcalc(Sin, Sout, lograte))
% estimate of step response function using Wiener filter/deconvolution method
% Sin = input signal, Sout = output signal
% returns matrix/stack of etimated stepresponse functions, time [t] in ms, and  
% rateHigh, where 1 means set point >=500 deg/s, and 0 < 500deg/s
%
%
% ----------------------------------------------------------------------------------
% "THE BEER-WARE LICENSE" (Revision 42):
% <brian.white@queensu.ca> wrote this file. As long as you retain this notice you
% can do whatever you want with this stuff. If we meet some day, and you think
% this stuff is worth it, you can buy me a beer in return. -Brian White
% ----------------------------------------------------------------------------------

segment_length=(lograte*1000); % 2 sec segments
wnd=(lograte*1000) * .5; % Nyquist  
StepRespDuration_ms=500; % max dur of step resp in ms for plotting
subsampleFactor=9;

segment_vector=1:round(segment_length/subsampleFactor):length(Sin);
NSegs=max(find((segment_vector+segment_length) < segment_vector(end)));
if NSegs>0
    Sinseg=[]; Soutseg=[];
    j=0;
    for i=1:NSegs
        j=j+1;
        Sinseg(j,:)=Sin(segment_vector(i):segment_vector(i)+segment_length-1);  
        Soutseg(j,:)=Sout(segment_vector(i):segment_vector(i)+segment_length-1); 
    end

    clear resp resp2 G H Hcon imp impf a b resptmp stepresponse
    j=0;
    if ~isempty(Sinseg)
        for i=1:size(Sinseg,1)
            a = Soutseg(i,:).*hann(length(Soutseg(i,:)))';
            b = Sinseg(i,:).*hann(length(Sinseg(i,:)))';
            padLength = 500;
            a = [zeros(1,padLength) a zeros(1,padLength)];
            b = [zeros(1,padLength) b zeros(1,padLength)];
            a = fft(a);
            b = fft(b);

            G=a/length(a);
            H=b/length(b);
            Hcon=conj(H);     
            imp=real(ifft((G .* Hcon) ./ (H .* Hcon + .0001)))'; % impulse response function, .0001 to avoid divide by 0
            resptmp(i,:) = cumsum(imp);% integrate impulse resp functions
             a=stepinfo(resptmp(i,1:wnd)); % (100*lograte) gather info about quality of step resp function
             if a.SettlingMin>.5 && a.SettlingMin<=1.1 && a.SettlingMax<2 && a.SettlingMax>=0.9 %Quality control
                j=j+1;
                stepresponse(j,:)=resptmp(i,1:wnd); 
             else
                 j=j+1;
                stepresponse(j,:)=zeros(1,wnd);  
            end      
            t = 1/lograte:1/lograte:StepRespDuration_ms;% time in ms        
        end 
    end
end

end




