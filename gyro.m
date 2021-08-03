SAMPLE_RATE = 2000;
SAMPLE_SIZE = 72;
BIN_RESOLUTION = SAMPLE_RATE / SAMPLE_SIZE;
BIN_COUNT = SAMPLE_SIZE / 2;
START_BIN = round(70 / BIN_RESOLUTION);
END_BIN = round(600 / BIN_RESOLUTION);
PEAK_COUNT = 3;
POINTER = 10000;
FRAME_COUNT = 100;

DYN_NOTCH_Q = 2.5;
DYN_NOTCH_SMOOTH_HZ = 20;
SMOOTH_FACTOR = 2 * pi * DYN_NOTCH_SMOOTH_HZ / SAMPLE_RATE;

% sin wave of increasing freq
t = 0:0.001:10;
f_in_start = 1;
f_in_end = 1000;
f_in = linspace(f_in_start, f_in_end, length(t));
dat = sin( f_in .* t);
dat=dat(1:length(dat)/2);
gyro_data = dat';

% gyro_data = readmatrix("log.xls");
% gyro_data = gyro_data(:, 6);

x = linspace(0, BIN_COUNT-1, BIN_COUNT);
window = hann(SAMPLE_SIZE);

%u = uicontrol('Style', 'slider', 'Position', [10 50 20 340], 'Min', 1, 'Max', FRAME_COUNT+1, 'Value', 1);

notchCenter = zeros(PEAK_COUNT, 1);
for i = 1:PEAK_COUNT
    notchCenter(i) = (i - 0.5)*(END_BIN - START_BIN) / PEAK_COUNT + START_BIN;
end

filter(PEAK_COUNT) = notchFilter;


for ptr = POINTER:(POINTER + FRAME_COUNT-1)
    
    tic;
  
    % - - - PREPARE DATA  - - - - - - - - - - - - - - - - - - - - - - - - -
    
    gyro_fft = gyro_data(ptr:(ptr + SAMPLE_SIZE - 1));
    gyro_fft = gyro_fft .* window;
    gyro_fft = abs(fft(gyro_fft));
    gyro_fft = gyro_fft(1:BIN_COUNT);
    
    gyro_rms = gyro_fft; % (START_BIN+1:END_BIN);
    gyro_rms = rms(gyro_rms);
    gyro_rms = gyro_rms ./ sqrt(x + 1);
    
    
    % - - - PEAK TRACKING - - - - - - - - - - - - - - - - - - - - - - - - -
    
    [peakAmp, peakBin] = findpeaks(gyro_fft);
    peaks = [peakBin, peakAmp];
    
    % Remove peaks outside of thresholds
    numRows = size(peaks, 1);
    rowToBeDeleted = false(numRows, 1);
    for i = 1:numRows
        if peaks(i,1)-1 <= START_BIN || peaks(i,1) >= END_BIN % || peaks(i,2) < gyro_rms(peaks(i,1))
            rowToBeDeleted(i) = true;
        end
    end
    peaks(rowToBeDeleted,:) = [];
    
    % Remove smallest peaks if number of peaks is greater than PEAK_COUNT
    rowToBeDeleted = 0;
    numRows = size(peaks, 1);
    while numRows > PEAK_COUNT
        rowToBeDeleted = find(min(peaks(:,2)) == peaks(:,2));
        peaks(rowToBeDeleted,:) = [];
        numRows = size(peaks, 1);
    end

    
    % - - - GET MEAN BINS - - - - - - - - - - - - - - - - - - - - - - - - -
    
    numRows = size(peaks, 1);
    for i = 1:numRows
       
        bin = peaks(i,1);
        y0 = gyro_fft(bin - 1);
        y1 = gyro_fft(bin);
        y2 = gyro_fft(bin + 1);
        
        y0 = log(y0);
        y1 = log(y1);
        y2 = log(y2);
        
        denom = 2 * (y0 - 2*y1 + y2);
        
        if denom ~= 0
            peaks(i,1) = peaks(i,1) + (y0 - y2) / denom;
        end

%         % accumulate fftSum and fftWeightedSum from peak bin, and shoulder bins either side of peak
%         squaredData = y1 * y1;
%         fftSum = squaredData;
%         fftWeightedSum = squaredData * bin;
% 
%         % accumulate upper shoulder unless it would be FFT_BIN_COUNT
%         squaredData = y2 * y2;
%         fftSum = fftSum +  squaredData;
%         fftWeightedSum = fftWeightedSum + squaredData * (bin+1);
% 
%         % accumulate lower shoulder unless lower shoulder would be bin 0 (DC)
%         squaredData = y0 * y0;
%         fftSum = fftSum + squaredData;
%         fftWeightedSum = fftWeightedSum + squaredData * (bin-1);
% 
%         peaks(i,1) = fftWeightedSum / fftSum;
            
        dynamicFactor = y1 / gyro_rms(bin);
        if dynamicFactor < 1
            dynamicFactor = 1;
        elseif dynamicFactor > 8
            dynamicFactor = 8;
        end
        
        notchCenter(i) = notchCenter(i) + SMOOTH_FACTOR * dynamicFactor * (peaks(i,1) - notchCenter(i) - 1);
                
    end    
    
    
    % - - - FILTER GYRO DATA  - - - - - - - - - - - - - - - - - - - - - - -

    gyro_filtered = gyro_data(ptr:(ptr + SAMPLE_SIZE - 1));
    
    for n = 1:PEAK_COUNT
        
        filter(n) = notchFilterUpdate(filter(n), notchCenter(n) * BIN_RESOLUTION, 1000000/SAMPLE_RATE, DYN_NOTCH_Q);
        
        for i = 1:SAMPLE_SIZE
           gyro_filtered(i) = notchFilterApply(filter(n), gyro_filtered(i));
        end
        
    end
    
    gyro_filtered = gyro_filtered .* window;
    gyro_filtered = abs(fft(gyro_filtered));
    gyro_filtered = gyro_filtered(1:BIN_COUNT);
    
    
    % - - - PLOT DATA - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    gyro_rms(1:BIN_COUNT) = gyro_rms;
    
    plot(x, gyro_rms, '--', 'Color', '#444444');
    
    hold on
    
    plot(x, gyro_filtered, 'LineWidth', 1.5, 'Color', '#D95319');
    
    hold on
    
    plot(x, gyro_fft, 'LineWidth', 1.5, 'Color', '#0072BD');
    
    hold on
    
    scatter(peaks(:,1)-1, peaks(:,2)+10, 'filled', 'v', 'MarkerFaceColor', '#0072BD')
    
    hold off
    
    for i = 1:PEAK_COUNT
       xline(notchCenter(i), ':', 'Color', '#0072BD', 'LineWidth', 1.5); 
    end
    
    xline(START_BIN, "--", 'startBin', 'Color', '#444444');
    xline(END_BIN, "--", 'endBin', 'Color', '#444444');
    
    
    % - - - PLOT SETTINGS - - - - - - - - - - - - - - - - - - - - - - - - -
    
    ax = gca;
    ax.XMinorTick = 'on';
    ax.YMinorTick = 'on';
    ax.TickDir = 'out';
    % set(ax, 'YScale', 'log')
    ylim([0,500])
    xlim([0,BIN_COUNT-1])
    grid on;
    
    txt = {'Frame: ' + string(ptr - POINTER + 1), 'NotchQ: ' + string(DYN_NOTCH_Q*100) + '  |  startBin: ' + string(START_BIN) + '  |  endBin: ' + string(END_BIN) + '  |  binRes: ' + string(BIN_RESOLUTION) + 'Hz'};
    legend('Noise floor', 'Filtered FFT', 'FFT', 'Peaks', 'Notches');
    title(txt);
    
    % Snapshot of every plot frames
    % movie(ptr-POINTER+1) = getframe(gcf);
    
    
    % - - - WAIT UNTIL  - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    deltaTime = toc;
    deltaTime = 0.1 - deltaTime;
    deltaTime = max(0, deltaTime);
    pause(deltaTime);
    
end