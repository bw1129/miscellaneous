function [output_signal] = biquad(filter, filterFreq, refreshRate, BIQUAD_Q, FILTER_LPF)

% see flight/pid.c  for notch and dterm filtering
% see sensors/gyro.c and gyro_init.c  for lpf gyro filtering - eg, biquadFilterUpdateLPF(&gyro.lowpassFilter[axis].biquadFilterState, cutoffFreq, gyro.targetLooptime);

% biquadFilterInitLPF, biquadFilterApply biquadFilterApplyDF1, 
% notch setup
function [notchQval] = filterGetNotchQ(centerFreq, cutoffFreq) 
    notchQval = centerFreq * cutoffFreq / (centerFreq * centerFreq - cutoffFreq * cutoffFreq);    
end

% sets up a biquad Filter 
function biquadFilterInitLPF(filter, filterFreq, refreshRate)
    biquadFilterInit(filter, filterFreq, refreshRate, Q, lpf);
end

function biquadFilterInit(filter, filterFreq, refreshRate, Q, filterType)
    %etup variables
    omega = 2.0 * pi * filterFreq * refreshRate * 0.000001;
    sn = sin(omega);
    cs = cos(omega);
    alpha = sn / (2.0 * Q);

    b0 = 0;
    b1 = 0;
    b2 = 0;
    a0 = 0;
    a1 = 0;
    a2 = 0;

    switch (filterType) 
    case FILTER_LPF
        %2nd order Butterworth (with Q=1/sqrt(2)) / Butterworth biquad section with Q
        % described in http://www.ti.com/lit/an/slaa447/slaa447.pdf
        b0 = (1 - cs) * 0.5;
        b1 = 1 - cs;
        b2 = (1 - cs) * 0.5;
        a0 = 1 + alpha;
        a1 = -2 * cs;
        a2 = 1 - alpha;
    case FILTER_NOTCH
        b0 =  1;
        b1 = -2 * cs;
        b2 =  1;
        a0 =  1 + alpha;
        a1 = -2 * cs;
        a2 =  1 - alpha;
    case FILTER_BPF
        b0 = alpha;
        b1 = 0;
        b2 = -alpha;
        a0 = 1 + alpha;
        a1 = -2 * cs;
        a2 = 1 - alpha;

    %precompute the coefficients
    filter.b0 = b0 / a0;
    filter.b1 = b1 / a0;
    filter.b2 = b2 / a0;
    filter.a1 = a1 / a0;
    filter.a2 = a2 / a0;

    % zero initial samples
    filter.x1 = 0; filter.x2 = 0;
    filter.y1 = 0; filter.y2 = 0;
    end
end

function biquadFilterUpdate(filter, filterFreq, refreshRate, Q, filterType)
% backup state
    x1 = filter.x1;
    x2 = filter.x2;
    y1 = filter.y1;
    y2 = filter.y2;
end

function biquadFilterInit(filter, filterFreq, refreshRate, Q, filterType)
    %restore state
    filter.x1 = x1;
    filter.x2 = x2;
    filter.y1 = y1;
    filter.y2 = y2;
end

function biquadFilterUpdateLPF(filter, filterFreq, refreshRate)
    biquadFilterUpdate(filter, filterFreq, refreshRate, Q, lpf);
end

% dynamic
function [rslt] = biquadFilterApplyDF1(filter, iput)
    % compute rslt 
    rslt = filter.b0 * iput + filter.b1 * filter.x1 + filter.b2 * filter.x2 - filter.a1 * filter.y1 - filter.a2 * filter.y2;

    % shift x1 to x2, iput to x1 
    filter.x2 = filter.x1;
    filter.x1 = iput;

    % shift y1 to y2, rslt to y1 
    filter.y2 = filter.y1;
    filter.y1 = rslt;
    end

    
function [rslt] = biquadFilterApply(filter, iput)
    rslt = filter.b0 * iput + filter.x1;
    filter.x1 = filter.b1 * iput - filter.a1 * rslt + filter.x2;
    filter.x2 = filter.b2 * iput - filter.a2 * rslt;
    end
    

end