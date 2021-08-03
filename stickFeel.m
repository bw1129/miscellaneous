function [rcCommandnew] = stickFeel(rcCommand)

    Plow=80; 
    Phigh=140; 
    Ilow=25; 
    Ihigh=40;
    Dlow=60;
    Dhigh=90;

    lastRcCommandData=0;
    iterm=0;
    pterm_low=[];
    pterm_high=[]; 
    pterm=[]; 
    iterm_low=[]; 
    iterm_high=[]; 
    dterm_low=[]; 
    dterm_high=[]; 
    dterm=[];
    
    rcCommandPercent=[];
    rcCommandError=[];
    
    if Plow ~= 100 || Phigh ~= 100 || Dlow > 0 || Dhigh > 0
        for i=1:length(rcCommand)
            rcCommandPercent(i) = abs(rcCommand(i)) / 500.0; % make rcCommandPercent go from 0 to 1

            pterm_low = (1.0 - rcCommandPercent(i)) * rcCommand(i) * (Plow / 100.0); % valid pterm values are between 50-150
            pterm_high = rcCommandPercent(i) * rcCommand(i) * (Phigh / 100.0);
            pterm = pterm_low + pterm_high;
            rcCommandError(i) = rcCommand(i) - (pterm + iterm);
            rcCommandnew(i) = pterm; % add this fake pterm to the rcCommand

            iterm_low = (1.0 - rcCommandPercent(i)) * rcCommandError(i) * (Ilow / 100.0); % valid iterm values are between 0-95
            iterm_high = rcCommandPercent(i) * rcCommandError(i) * (Ihigh / 100.0);
            iterm = iterm + (iterm_low + iterm_high);
            rcCommandnew(i) = rcCommandnew(i) + iterm; % add the iterm to the rcCommand

            dterm_low = (1.0 - rcCommandPercent(i)) * (lastRcCommandData - rcCommandnew(i)) * (Dlow / 100.0); % valid dterm values are between 0-95
            dterm_high = rcCommandPercent(i) * (lastRcCommandData - rcCommandnew(i)) * (Dhigh / 100.0);
            dterm = dterm_low + dterm_high;
            rcCommandnew(i) = rcCommandnew(i) + dterm; % add dterm to the rcCommand (this is real dterm)
            
            lastRcCommandData = rcCommandnew(i);
        end
    end
end