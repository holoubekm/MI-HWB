more off
tic
disp load

pkg load signal

directory = './';
tracesLengthFile = fopen([directory 'traceLength.txt'],'r');
traceLength      = fscanf(tracesLengthFile, '%d');
numOfTraces      = 200;
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

x = traces(1,:);
y = traces(45,:) - 10;
z = traces(90,:) - 20;
#z = traces(3,150000:165000) - 0;
plot([x' y' z']);
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
