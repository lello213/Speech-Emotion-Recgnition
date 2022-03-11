function En=Energy(file) 
[sig]=audioread(file);
ggg = fft(sig);
En=sum(abs(ggg).^2)/numel(sig)
end