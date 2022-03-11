folder = fullfile('G:\Matlab 2012b','New folder','AudioWAV');
ADS = audioDatastore(folder);
read(ADS);
actorsinfo=readtable("VideoDemographics.csv");

audiotest="DR. Darazi Angry.wav";
[sig,Fs] = audioread(audiotest);
sig=sig(:,1);
sound(sig,Fs);
allData = readall(ADS);

%Cross correlation is used to compare multiple time series and objectively determine how well they match up with each other 
m = cellfun(@(x)max(xcorr(x,sig)), allData, 'UniformOutput', false);
[~,index2] = maxk(cell2mat(m),3);

[sig1,Fs1] = audioread(ADS.Files{index2(1)});
[sig2,Fs2]=audioread(ADS.Files{index2(2)});
[sig3,Fs3]=audioread(ADS.Files{index2(3)});

a1=ADS.Files(index2(1));
info1=audioinfo(string(a1));
[filepath1,name1,ext1]=fileparts(a1);

a2=ADS.Files(index2(2));
info2=audioinfo(string(a2));
[filepath2,name2,ext2]=fileparts(a2);

a3=ADS.Files(index2(3));
info3=audioinfo(string(a3));
[filepath3,name3,ext3]=fileparts(a3);

path1=ADS.Files{index2(1)};
path2=ADS.Files{index2(2)};
path3=ADS.Files{index2(3)};

% Correlation:is a measurement that tracks the movements of two or more sets of time series data relative to one another.
figure('Name','Correlation')
subplot(3,1,1);
[c1,lags1] = xcorr(sig,sig1,30);
stem(lags1,c1)
title('Original Signal and Signal 1');
subplot(3,1,2);
[c2,lags2] = xcorr(sig,sig2,30);
stem(lags2,c2)
title('Original Signal and Signal 2');
subplot(3,1,3);
[c3,lags3] = xcorr(sig,sig3,30);
stem(lags3,c3)
title('Original Signal and Signal 3');

% Speech Rate :avg number of words / second
figure('Name','Speech Rate')
subplot(2,2,1);
[NW,SR]=Speech_Rate(sig,Fs);
title('Original audio');
subplot(2,2,2);
[NW1,SR1]=Speech_Rate(sig1,Fs1);
title(name1);
subplot(2,2,3);
[NW2,SR2]=Speech_Rate(sig2,Fs2);
title(name2);
subplot(2,2,4);
[NW3,SR3]=Speech_Rate(sig3,Fs3);
title(name3);

%Pitch: is the quality that makes it possible to judge sounds as "higher" and "lower" (Fundamental Frequency)
P=pitch(sig,16000);
P1=pitch(sig1,16000);
P2=pitch(sig2,16000);
P3=pitch(sig3,16000);

Pt=sqrt(sum(P)^2);
Pt1=sqrt(sum(P1)^2);
Pt2=sqrt(sum(P2)^2);
Pt3=sqrt(sum(P3)^2);

figure('Name','Pitch')
numBins = 20;
subplot(3,1,1);
histogram(P,numBins,"Normalization","probability");
hold on
histogram(P1,numBins,"Normalization","probability");
legend('Origina Voice',name1)
xlabel('Pitch (Hz)')
ylabel('Probability')
hold off

subplot(3,1,2);
histogram(P,numBins,"Normalization","probability");
hold on
histogram(P2,numBins,"Normalization","probability");
legend('Origina Voice',name2)
xlabel('Pitch (Hz)')
ylabel('Probability')
hold off

subplot(3,1,3);
histogram(P,numBins,"Normalization","probability");
hold on
histogram(P3,numBins,"Normalization","probability");
legend('Origina Voice',name3)
xlabel('Pitch (Hz)')
ylabel('Probability')
hold off

%MFCC:is the rate at which sound energy is emitted, reflected, transmitted or received, per time unit 
win = hann(1024,"periodic");
nbins = 60;
coefficientToAnalyze = 4;
S = stft(sig,"Window",win,"OverlapLength",512,"Centered",false);
coeffs = mfcc(audiotest);

figure('Name','MFCC')
subplot(3,1,1);
S1 = stft(sig1,"Window",win,"OverlapLength",512,"Centered",false);
coeffs1 = mfcc(path1)
histogram(coeffs(:,coefficientToAnalyze+1),nbins,"Normalization","pdf")
hold on
histogram(coeffs1(:,coefficientToAnalyze+1),nbins,"Normalization","pdf")
legend('Origina Voice',name1)
hold off

subplot(3,1,2);
S2 = stft(sig2,"Window",win,"OverlapLength",512,"Centered",false);
coeffs2 = mfcc(path2);
histogram(coeffs(:,coefficientToAnalyze+1),nbins,"Normalization","pdf")
hold on
histogram(coeffs2(:,coefficientToAnalyze+1),nbins,"Normalization","pdf")
legend('Origina Voice',name2)
hold off

subplot(3,1,3);
S3 = stft(sig3,"Window",win,"OverlapLength",512,"Centered",false);
coeffs3 = mfcc(path3);
histogram(coeffs(:,coefficientToAnalyze+1),nbins,"Normalization","pdf")
hold on
histogram(coeffs3(:,coefficientToAnalyze+1),nbins,"Normalization","pdf")
legend('Origina Voice',name3)
hold off

MFCCt=sqrt(sum(coeffs.^2));
MFCCtot=sqrt(sum(MFCCt.^2));
MFCCt1=sqrt(sum(coeffs1.^2));
MFCCtot1=sqrt(sum(MFCCt1.^2));
MFCCt2=sqrt(sum(coeffs2.^2));
MFCCtot2=sqrt(sum(MFCCt2.^2));
MFCCt3=sqrt(sum(coeffs3.^2));
MFCCtot3=sqrt(sum(MFCCt3.^2));

%Entropy: is a measure of the width and uniformity of the power spectrum
figure('Name','Entropy')
subplot(2,2,1);
Entr=Entropy(audiotest);
plot(Entr);
title('Original Audio');
subplot(2,2,2);
Entr1=Entropy(path1);
plot(Entr1);
title(name1);
subplot(2,2,3);
Entr2=Entropy(path2);
plot(Entr2);
title(name2);
subplot(2,2,4);
Entr3=Entropy(path3);
plot(Entr3);
title(name3);

Entrm=sqrt(sum(Entr).^2);
Entrm1=sqrt(sum(Entr1).^2);
Entrm2=sqrt(sum(Entr2).^2);
Entrm3=sqrt(sum(Entr3).^2);

%Energy 
E=(Energy(audiotest));
E1=Energy(path1);
E2=Energy(path2);
E3=Energy(path3);

%Result
id1=name1(1:4);
n1 = str2num(id1);
i1 = find(actorsinfo.ActorID==n1);
actorsex1=char(actorsinfo.Sex(i1));
actorage1=actorsinfo.Age(i1);
actorRace1=char(actorsinfo.Race(i1));
actorEthnicity1=char(actorsinfo.Ethnicity(i1));

id2=name2(1:4);
n2 = str2num(id2);
i2 = find(actorsinfo.ActorID==n2);
actorsex2=char(actorsinfo.Sex(i2));
actorage2=actorsinfo.Age(i2);
actorRace2=char(actorsinfo.Race(i2));
actorEthnicity2=char(actorsinfo.Ethnicity(i2));

id3=name3(1:4);
n3 = str2num(id3);
i3 = find(actorsinfo.ActorID==n3);
actorsex3=char(actorsinfo.Sex(i3));
actorage3=actorsinfo.Age(i3);
actorRace3=char(actorsinfo.Race(i3));
actorEthnicity3=char(actorsinfo.Ethnicity(i3));

fprintf('These are the results that matched with the database: ')
fprintf('\n')
fprintf('RESULT #1 with a correlation coefficient of ')
fprintf(num2str(m{index2(1)}))
fprintf('\n')
fprintf('Expected Emotion with voice intensity: ')
fprintf(name1(10:end))
fprintf('\n')
fprintf('Expected Speaker Gender: ')
fprintf(actorsex1)
fprintf('\n')
fprintf('Expected Speaker Age: ')
fprintf(num2str(actorage1))
fprintf('\n')
fprintf('Expected Speaker Race: ')
fprintf(actorRace1)
fprintf('\n')
fprintf('Expected Speaker Ethnicity: ')
fprintf(actorEthnicity1)
fprintf('\n')

fprintf('These are the results that matched with the database: ')
fprintf('\n')
fprintf('RESULT #2 with a correlation coefficient of ')
fprintf(num2str(m{index2(2)}))
fprintf('\n')
fprintf('Expected Emotion with voice intensity: ')
fprintf(name2(10:end))
fprintf('\n')
fprintf('Expected Speaker Gender: ')
fprintf(actorsex2)
fprintf('\n')
fprintf('Expected Speaker Age: ')
fprintf(num2str(actorage2))
fprintf('\n')
fprintf('Expected Speaker Race: ')
fprintf(actorRace2)
fprintf('\n')
fprintf('Expected Speaker Ethnicity: ')
fprintf(actorEthnicity2)
fprintf('\n')

fprintf('These are the results that matched with the database: ')
fprintf('\n')
fprintf('RESULT #3 with a correlation coefficient of ')
fprintf(num2str(m{index2(3)}))
fprintf('\n')
fprintf('Expected Emotion with voice intensity: ')
fprintf(name3(10:end))
fprintf('\n')
fprintf('Expected Speaker Gender: ')
fprintf(actorsex3)
fprintf('\n')
fprintf('Expected Speaker Age: ')
fprintf(num2str(actorage3))
fprintf('\n')
fprintf('Expected Speaker Race: ')
fprintf(actorRace3)
fprintf('\n')
fprintf('Expected Speaker Ethnicity: ')
fprintf(actorEthnicity3)
fprintf('\n')