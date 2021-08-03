 function z=myFFT(x)

N=length(x);
nfft=2^ceil(log2(N));
z=zeros(1,nfft);
s=0;
for k=1:nfft
    for jj=1:N
        s=s+x(jj)*exp(-2*pi*(jj-1)*(k-1)/nfft);
    end
z(k)=s;
s=0;% Reset
end



% function z=myFFT(x,nfft)
% 
% N=length(x);
% z=zeros(1,nfft);
% Sum=0;
% for k=1:nfft
%     for jj=1:N
%         Sum=Sum+x(jj)*exp(-2*pi*j*(jj-1)*(k-1)/nfft);
%     end
% z(k)=Sum;
% Sum=0;% Reset
% end
% return