load tab.mat;

cd('data3');
bfile = fopen('traces.bin', 'rb');
lfile = fopen('traceLength.txt', 'r');
traceLength = fscanf(lfile, '+%d');
fclose(lfile);

traces = 500;

# 500 x 290 000 bytes 
# | rubbish -> roundOffset | data -> roundLength | rubbish -> roundTail |
# ...

roundStart = 11000; roundEnd = 50000; #data0
roundStart = 48000; roundEnd = 100000; #data1
roundStart = 5000; roundEnd = 60000; #data2
roundStart = 5000; roundEnd = 60000; #data2

roundLength = roundEnd - roundStart;
roundTail = traceLength - roundEnd;

#fread(bfile, 290000, 'uint8')
#bdata = fread(bfile, 290000, 'uint8');

rounds = zeros(traces, roundLength, 'uint8');
#y = zeros(traces, roundLength, 'uint8');
y = [];
for i = 1:traces # put traces variable here!
  fseek(bfile, roundStart, 'cof');
  round = fread(bfile, roundLength, 'uint8')';
  if(i == 1)
    y(i,:) = round;
  end
  rounds(i,:) = byte_Hamming_weight(round + 1); #Convert zero based indexing to Octave fuckin.. kiddin.. indexing
  fseek(bfile, roundTail, 'cof');
end
fclose(bfile);

%figure(1);
x = 1:length(y(1,:));
#plot (x, y(1,:));

ptfile = fopen('plaintext.txt', 'r');
ptxts = fscanf(ptfile, '%x');
ptxts = ptxts(1:traces * 16);
fclose(ptfile);
ptxts = reshape(ptxts, 16, traces).'; # transpose to make a 500 x 16 rainbow

for keybyte = 1:1
  guesses = [];
  for byte = 0:255
    ptxt = ptxts(:,keybyte); # Extract column from the plaintext matrix
    xored = bitxor(byte, ptxt);
    
    xored = SubBytes(xored+1); #Convert zero based indexing to Octave fuckin.. kiddin.. indexing
    xored = byte_Hamming_weight(xored+1)'; #Convert zero based indexing to Octave fuckin.. kiddin.. indexing
    
    guesses = [guesses xored];
  end
  cors = corr(guesses, rounds);
  corsA = abs(cors);
  [m,i] = max(corsA(:));
  val = cors(i);
  [resByte, resTime] = ind2sub(size(corsA),i);
  resByte--;
  resTime--;
  fprintf('%05d, byte[%02d]: 0x%02x, %f\n', resTime, keybyte, resByte, val);
end

cd('..');
