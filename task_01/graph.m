cd('data2');

bfile = fopen('traces.bin', 'rb');
tlfile = fopen('traceLength.txt', 'r');
roundLength = fscanf(tlfile, '+%d');
fclose(tlfile);

tracesCnt = 1;
len = 60000;
s = 1;
e = s + len - 1;
traces = zeros(tracesCnt, len, 'uint8');
for i = 1:tracesCnt
  trace = fread(bfile, roundLength, 'uint8');
  traces(i,:) = trace(s:e);
 end
fclose(bfile);

###########################
figure(1);
x = 1:length(traces(1,:));
#plot (x, round_1, x, round_100, x, round_200);
plot (x, traces);
xlabel ("no. sample");
ylabel ("sample value [0-255]");
title ("Complete traces 1st, 100th, 200th");

cd('..');
return;

###########################
figure(2);
hist(round_1);
xlabel ("Sample value [0-255]");
colormap (summer ());
ylabel ("Value count");
title ("Histogram of observed value");


 
###########################
rounds = [];
bfile = fopen('data2/traces.bin', 'rb');
for n = 1:100
  round = fread(bfile, roundLength, 'uint8')';
  rounds = [rounds; round];
end
fclose(bfile);
meanrounds = mean(rounds);

###
figure(3);
startmean = meanrounds(:,1:25000);
x = 1:length(startmean);
plot (x, startmean);
xlabel ("no. sample");
ylabel ("sample value [0-255]");
title ("Mean of 100 samples - start");

###
figure(4);
centermean = meanrounds(:,100000:125000);
x = 1:length(centermean);
plot (x, centermean);
xlabel ("no. sample");
ylabel ("sample value [0-255]");
title ("Mean of 100 samples - center");

###
figure(5);
endmean = meanrounds(:,end-25000:end);
x = 1:length(endmean);
plot (x, endmean);
xlabel ("no. sample");
ylabel ("sample value [0-255]");
title ("Mean of 100 samples - end");
