% (C) Ing. Jiri Bucek, Petr Vyleta

more off
tic
disp load

directory = '../data/triggerless/2/';
tracesLengthFile = fopen([directory 'traceLength.txt'],'r');
traceLength      = fscanf(tracesLengthFile, '%d');
numOfTraces      = 100;
startPoint       = 0;
points           = traceLength;
plaintextLength  = 16;

traces = tracesInput([directory 'traces.bin'], traceLength, startPoint ,points, numOfTraces);
toc
disp('mean correction')
mm     = mean(mean(traces));
tm     = mean(traces, 2);
traces = traces - tm(:,ones(1,size(traces,2))) + mm;
toc

skipCnt = 2;
reducedPoints = points / skipCnt;
compressed = zeros(numOfTraces,reducedPoints);
vals = zeros(1,reducedPoints);

for p = 1:skipCnt:reducedPoints
  compressed(:,p) = max(traces(:,p:p+skipCnt-1),[],2);
end

#traces = compressed; 
plot([traces(1,2000:2500)' traces(100,2000:2500)'])
traces = compressed;  
return


#traces = traces(:,1:150000);

disp('load text')
inputs = plaintextInput([directory 'plaintext.txt'], plaintextLength, numOfTraces);

disp('power hypotheses')
load tab.mat

htraces = traces;

guesses = zeros(numOfTraces,256,16, 'uint8');
for i = 1:16
  guess = [];
  for byte = 0:255
    input = inputs(:,i);
    xored = bitxor(byte, input);
    xored = SubBytes(xored+1);
    xored = byte_Hamming_weight(xored+1)';
    guess = [guess xored];
  end
  cors = myCorrcoef(guess, htraces);
  corsA = abs(cors);
  [m,x] = max(corsA(:));
  val = cors(x);
  [resByte, resTime] = ind2sub(size(corsA), x);
  resByte--;
  resTime--;
  fprintf('%05d, 0x%02x, %f\n', resTime, resByte, val);
  toc
end
