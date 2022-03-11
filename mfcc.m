function MFCC=mfcc(file);
%The MFCC feature extraction technique basically includes windowing the signal, applying the DFT, 
% taking the log of the magnitude, and then warping the frequencies on a Mel scale, followed by applying the inverse DCT.
[file,fs]=audioread(file);
aFE = audioFeatureExtractor("SampleRate",fs,"mfcc",true); 
features=extract(aFE,file);
MFCC=features;
end
