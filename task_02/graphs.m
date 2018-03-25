more off
tic
disp load

directory = 'traces/4Koko/';
tracesLengthFile = fopen([directory 'traceLength.txt'],'r');
traceLength      = fscanf(tracesLengthFile, '%d');
numOfTraces      = 1;
startPoint       = 0;
points           = traceLength;
plaintextLength  = 16;

traces = tracesInput([directory 'traces.bin'], traceLength, startPoint ,points, numOfTraces);
plot(traces)
