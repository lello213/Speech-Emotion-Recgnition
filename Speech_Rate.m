function [nw,sr]=speechRate(file,Fs);
Sig=file;
nSig = Sig / max(abs(Sig)); % to adjust the recording's amplitude to a level where words are said
[idx,thresholds] = detectSpeech(Sig,Fs); % function that detects intervals of time where there is a speech 
thr1=min(thresholds); % minimum threshold (silence is detected)
word=1; 
w=find(abs(nSig)>thr1); % find part of signal where words are detected
n=length(w); 
for i=1:n-1 
if w(i+1)-w(i)>300 % if the interval difference between peak to peak amplitude is greater than 300 ms
   word=word+1; % increment the word by 1
end
end
V=length(Sig);
V1=V/Fs; % to get the exact duration of the signal
nw=word 
sr=round(nw/V1); % speech rate
plot(abs(nSig)) 







