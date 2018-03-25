more off
tic
disp load

pkg load signal

directory = 'data/hidingInTime/1_aligned/';
tracesLengthFile = fopen([directory 'traceLength.txt'],'r');
traceLength      = fscanf(tracesLengthFile, '%d');
numOfTraces      = 10;
startPoint       = 0;
points           = traceLength;
plaintextLength  = 16;


#a = [1 2 3 4 5 6 7 8 9];
#b = [4 5 6 7 8 9 1 2 3];
#[cors,lags] = xcorr(a, b);
#[m, im] = max(abs(cors));
#lag = lags(im);
#c=circshift(b, lag, 2);
#a
#b
#c
#return

traces = tracesInput([directory 'traces.bin'], traceLength, startPoint ,points, numOfTraces);

w = 2;
from = 270001;
to = from + 160000;

x = traces(2,:);
#x = x - mean(x);
x = reshape(x, w, []);
x = sum(x);

ref = x(from:to);
maxLag = 50;
halfLag = maxLag / 2;
cors = zeros(1, maxLag);


y = traces(3,:);
#y = y - mean(y);
y = reshape(y, w, []);
y = sum(y);

aaa=repmat(y(from:to),100);
return

for i = -halfLag:halfLag
  chunk = y(from+i:to+i);
  cors(halfLag + i + 1) = corr(ref, chunk);
end
  [~,cori] = max(abs(cors));
  lag = cori - halfLag - 1;

  tr1 = x(370001:370500);
  tr2 = y(370001:370500);
  tr2 = circshift(tr2, -lag, 2);
  
  lag
  plot([tr1' tr2'])
  
return
  y = traces(3,:);
  #y = y - mean(y);
  y = reshape(y, w, []);
  y = sum(y);

  chunk = y(from:to);
  [cors, lags] = xcorr(x, chunk, maxlag=10000);
  [m, im] = max(abs(cors))
  lag = lags(im)
  
  plot(lags, cors)
tr1 = x;
tr2 = y;
tr2 = circshift(tr2, lag, 2);
return
corr(tr1, tr2)

tr1=tr1(from:to);
tr2=tr2(from:to);
plot([tr1' tr2'])
