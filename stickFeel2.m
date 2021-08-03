function [rcCommand] = stickFeel2(rcCommand)

    % user adjustable parameters/gains
    Pcenter=85; 
    Pend=140; 
    Icenter=80; 
    Iend=20;
    Dcenter=15;
    Dend=15;

    lastRcCommandData=0;
    iterm=0;
    pterm_center=[];
    pterm_end=[]; 
    pterm=[]; 
    iterm_center=[]; 
    iterm_end=[]; 
    dterm_center=[]; 
    dterm_end=[]; 
    dterm=[];
    
    rcCommandPercent=[];
    rcCommandError=[];
    
    if Pcenter ~= 100 || Pend ~= 100 || Dcenter > 0 || Dend > 0
     
            rcCommandPercent = abs(rcCommand) / 500.0; % make rcCommandPercent go from 0 to 1

            pterm_center = (1.0 - rcCommandPercent) * rcCommand * (Pcenter / 100.0); % valid pterm values are between 50-150
            pterm_end = rcCommandPercent * rcCommand * (Pend / 100.0);
            pterm = pterm_center + pterm_end;
            rcCommandError = rcCommand - (pterm + iterm);
            rcCommand = pterm; % add this fake pterm to the rcCommand

            iterm_center = (1.0 - rcCommandPercent) * rcCommandError * (Icenter / 100.0); % valid iterm values are between 0-95
            iterm_end = rcCommandPercent * rcCommandError * (Iend / 100.0);
            iterm = iterm + (iterm_center + iterm_end);
            rcCommand = rcCommand + iterm; % add the iterm to the rcCommand

            dterm_center = (1.0 - rcCommandPercent) * (lastRcCommandData - rcCommand) * (Dcenter / 100.0); % valid dterm values are between 0-95
            dterm_end = rcCommandPercent * (lastRcCommandData - rcCommand) * (Dend / 100.0);
            dterm = dterm_center + dterm_end;
            rcCommand = rcCommand + dterm; % add dterm to the rcCommand
            
            lastRcCommandData = rcCommand;
    end
end

%%%% ORIGINAL CODE IN:
% https://github.com/emuflight/EmuFlight/blob/master/src/main/fc/fc_rc.c
% 
% FAST_CODE float rateDynamics(float rcCommand, int axis)
% {
%   static FAST_RAM_ZERO_INIT float lastRcCommandData[3];
%   static FAST_RAM_ZERO_INIT float iterm[3];
% 
%   if (((currentControlRateProfile->rateDynamics.rateSensCenter != 100) || (currentControlRateProfile->rateDynamics.rateSensEnd != 100)) || ((currentControlRateProfile->rateDynamics.rateWeightCenter > 0) || (currentControlRateProfile->rateDynamics.rateWeightEnd > 0)))
%   {
%     float pterm_centerStick, pterm_endStick, pterm, iterm_centerStick, iterm_endStick, dterm_centerStick, dterm_endStick, dterm;
%     float rcCommandPercent;
%     float rcCommandError;
%     rcCommandPercent = fabsf(rcCommand) / 500.0f; // make rcCommandPercent go from 0 to 1
% 
%     pterm_centerStick = (1.0f - rcCommandPercent) * rcCommand * (currentControlRateProfile->rateDynamics.rateSensCenter / 100.0f); // valid pterm values are between 50-150
%     pterm_endStick = rcCommandPercent * rcCommand * (currentControlRateProfile->rateDynamics.rateSensEnd / 100.0f);
%     pterm = pterm_centerStick + pterm_endStick;
%     rcCommandError = rcCommand - (pterm + iterm[axis]);
%     rcCommand = pterm; // add this fake pterm to the rcCommand
% 
%     iterm_centerStick = (1.0f - rcCommandPercent) * rcCommandError * (currentControlRateProfile->rateDynamics.rateCorrectionCenter / 100.0f); // valid iterm values are between 0-95
%     iterm_endStick = rcCommandPercent * rcCommandError * (currentControlRateProfile->rateDynamics.rateCorrectionEnd / 100.0f);
%     iterm[axis] += iterm_centerStick + iterm_endStick;
%     rcCommand = rcCommand + iterm[axis]; // add the iterm to the rcCommand
% 
%     dterm_centerStick = (1.0f - rcCommandPercent) * (lastRcCommandData[axis] - rcCommand) * (currentControlRateProfile->rateDynamics.rateWeightCenter / 100.0f); // valid dterm values are between 0-95
%     dterm_endStick = rcCommandPercent * (lastRcCommandData[axis] - rcCommand) * (currentControlRateProfile->rateDynamics.rateWeightEnd / 100.0f);
%     dterm = dterm_centerStick + dterm_endStick;
% 
%     rcCommand = rcCommand + dterm; // add dterm to the rcCommand (this is real dterm)
%     lastRcCommandData[axis] = rcCommand;
%   }
%     return rcCommand;
% }