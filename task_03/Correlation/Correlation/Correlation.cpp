#include "stdafx.h"

using namespace std;

typedef uint32_t uint;
typedef uint8_t byte;


int main() {
	const string inFolder = "inData/";
	const string outFolder = "outData/";
	const int cntTraces = 500;
	const int cntSum = 5;
	uint traceLength = 0; 

	int alignStart = 870000;
	int alignEnd = 920000;
	alignStart = alignStart / cntSum;
	alignEnd = alignEnd / cntSum;
	int alignSize = alignEnd - alignStart;
	int maxLag = 100000;
	maxLag = maxLag / cntSum;

	ifstream ifTracesLength(inFolder + "traceLength.txt");
	ifTracesLength >> traceLength;
	ifTracesLength.close();

	uint sumLength = (traceLength + cntSum - 1) / cntSum;
	ofstream ofTracesLength(outFolder + "traceLength.txt");
	ofTracesLength << sumLength << endl;
	ofTracesLength.close();

	auto buf = new byte[traceLength];
	auto traces = new byte*[cntTraces];
	for (int i = 0; i < cntTraces; i++) {
		traces[i] = new byte[sumLength];
		memset(traces[i], 0x0, sumLength);
	}

	ifstream ifTraces(inFolder + "traces.bin", ios::binary);
	istream_iterator<byte> start(ifTraces);
	for (int i = 0; i < cntTraces; i++) {
		ifTraces.read(reinterpret_cast<char*>(buf), traceLength);
		for (uint j = 0; j < sumLength; j++) {
			uint64_t tmp = 0;
			for (int k = 0; k < cntSum; k++) { 
				tmp += buf[min(j * cntSum + k, traceLength - 1)];
			} 
			traces[i][j] = static_cast<byte>(tmp / cntSum);
		}
	}
	ifTraces.close();
	delete[] buf;

	auto refI = 0;
	auto ref = traces[refI];
	auto halfLag = maxLag / 2;
	auto shifts = new int[cntTraces];
	auto cors = new double[maxLag];
	double refMean = 0;
	for (int i = 0; i < alignSize; i++)
		refMean += ref[alignStart + i];
	refMean /= alignSize;

	double refDev = 0;
	for (int i = 0; i < alignSize; i++)
		refDev += pow(ref[alignStart + i] - refMean, 2.0);
	refDev /= (alignSize - 1);
	refDev = sqrt(refDev);

	for (int i = 0; i < cntTraces; i++) {
		double curMeanDenorm = 0;
		for (int j = 0; j < alignSize; j++)
			curMeanDenorm += traces[i][alignStart - halfLag + j];
		double curMean = curMeanDenorm / alignSize;
			
		double curDevDenorm = 0;
		for (int j = 0; j < alignSize; j++)
			curDevDenorm += pow(traces[i][alignStart - halfLag + j] - curMean, 2.0);
			
		curMeanDenorm -= traces[i][alignStart - halfLag + alignSize - 1];
		curDevDenorm -= pow(traces[i][alignStart - halfLag + alignSize - 1] - curMean, 2.0);
			
		for (int j = -halfLag; j < halfLag; j++) {
			curMeanDenorm += traces[i][alignStart + alignSize + j - 1];
			curMean = curMeanDenorm / alignSize;
			curDevDenorm += pow(traces[i][alignStart + alignSize + j - 1] - curMean, 2.0);
			auto curDev = curDevDenorm / (alignSize - 1);
			curDev = sqrt(curDev);
			double corrMul = 0;
			for (int k = 0; k < alignSize; k++)
				corrMul += ref[alignStart + k] * traces[i][alignStart + j + k];
			auto corr = corrMul - alignSize * curMean * refMean;
			corr /= (alignSize - 1);
			corr /= curDev;
			corr /= refDev;

			cors[halfLag + j] = corr;
				
			curMeanDenorm -= traces[i][alignStart + j];
			curDevDenorm -= pow(traces[i][alignStart + j] - curMean, 2.0);
		}
		auto val = max_element(cors, cors + maxLag);
		auto index = distance(cors, val);
		auto shift = index - halfLag;
		cout << "max Cor: " << cors[index] << " at: " << index << ", shift: " << shift << endl;
		shifts[i] = shift;
		//system("pause");
	}

	cout << "Writing output" << endl;
	delete[] cors;
	ofstream ofTraces(outFolder + "traces.bin", ios::binary);
	for (uint i = 0; i < cntTraces; i++) {
		auto shift = shifts[i];
		if (shift < 0) {
			ofTraces.write(reinterpret_cast<char*>(traces[i] + sumLength + shift), -shift);
			ofTraces.write(reinterpret_cast<char*>(traces[i]), sumLength + shift);
		}
		else {
			ofTraces.write(reinterpret_cast<char*>(traces[i] + shift), sumLength - shift);
			ofTraces.write(reinterpret_cast<char*>(traces[i] + sumLength - shift), shift);
		}
	}
	ofTraces.close();
	delete[] shifts;
	for (uint i = 0; i < cntTraces; i++)
		delete[] traces[i];
	delete[] traces;

	cout << traceLength << endl;
	system("pause");
    return 0;
}

