# MI-HWB.16 Course
## Hardwarová bezpečnost
### CTU / ČVUT FIT

The whole semestr was touching hardware security, counter measurements and it's implications. Our biggest challenge was to break AES implemented in the java card using differential power analysis.

#### Task 1
We got an oscilloscope to measure power consumption of a small java card device. After successful measurement we were told to make inner resistance estimation. Data saved from the probe were plotted using `Mathlab` or `GNU Octave`. Results can be found in the `task_01/results` folder. Matlab source code are available as well

#### Task 2
Extension of the previous task. We captured data again during the encryption phase performed in the card. Using an auxiliary signal implemented in hardware to make a whole process easier we were able to break the cipher and gain the cipher key.

This folder contains 4 different version of `Mathlab` ~~(methlab)~~ code, varying in the target round of encryption and presumptions of information leakage during the process. 

We were actually able to break the cipher using all above methods, but for example `DPA_Bit_02` attacking the 2nd bit of internal value was really hard to perform in terms of measurement quality and precision.

### Task 3
Another continuation of differenctial power analysis (`DPA`). The assignment was hardened a little bit in the comparison with previous. We had to measure tremendous amount of data. This lead to necessity of compression and to cutting unnecessary parts of it.

In the `task_03/Correlation` folder is a Visual Studio solution efficiently performing correlation analysis between two inputs, moving one along the other trying to maximize correlation output and findout the best relative position.

The directory contains as well solutions to all those tasks code in the GNU Octave (un)efficiently solving those tasks. 
