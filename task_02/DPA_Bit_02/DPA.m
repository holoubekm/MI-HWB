% (C) Ing. Jiri Bucek, Petr Vyleta

more off
tic
disp load

directory = '../traces/4Koko/';
tracesLengthFile = fopen([directory 'traceLength.txt'],'r');
traceLength      = fscanf(tracesLengthFile, '%d');
numOfTraces      = 200;
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

traces = traces(:,13000:58000);

disp('load text')
inputs = plaintextInput([directory 'plaintext.txt'], plaintextLength, numOfTraces);

disp('power hypotheses')
load tab.mat

val = 0x02;

htraces = traces;
htraces = bitand(htraces, val);

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
  %toc
end
