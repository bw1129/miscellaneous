function y = epsp(tg, td, k, c)
% tg = growth time (ms), td = decay time (ms), k ~ kurtosis , c = constant
% ideal k ~ 1 to 3, 1.5 decent.
% c used to adjust proper absolute firing rate
% 2, 20, 1.5, .95 are decent inputs
%  -B. White (2017)
 
t=0:td-1;
 
y = ( (t.*exp( (-t./(tg)) / k) ) / k ) * c;
