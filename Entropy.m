function entropy=Entropy(Sig); 
%The spectral entropy of a signal is a measure of its spectral power distribution (signal irregularity)
% The concept is based on the Shannon entropy,
[audioIn,fs] = audioread(Sig);
entropy = spectralEntropy(audioIn,fs); 
end