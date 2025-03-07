# DTMFDecoderApp
The DTMF Decoder App is a MATLAB-based app that decodes Dual-Tone Multi-Frequency (DTMF) signals

## Example 
Demonstration of how app works is in film in project repository - HowTheAppWorks.mp4

## Overview
DTMFDecoderApp is a tone recognition app which decodes digits from tones.
Code records an audio signal from computer built-in microphone, analyzes its frequency components performing FFT and filtering, and then decodes the signal into DTMF (Dual-tone multi-frequency) tones. It is classic approach to tone recognition. The code can decode 16 digits ( 1,2,3,4,5,6,7,8,9,*,0,#,A,B,C,D) Each digit on a telephone keypad is encoded using a combination of two specific frequencies.

Key	Low Frequency (Hz)	High Frequency (Hz)
1	697			1209
2	697			1336
3	697			1477
4	770			1209
5	770			1336
6	770			1477
7	852			1209
8	852			1336
9	852			1477
*	941			1209
0	941			1336
#	941			1477
A	697			1633
B	770			1633
C	852			1633
D	941			1633 

## Usage

Run the DTMFDecoderApp.m script to launch the application.<br />
Click the Start button to begin recording.<br />
The app will display:<br />

-The recorded signal in the time domain.<br />

-The frequency spectrum of the recorded audio.<br />

-The decoded digits.<br />
Requirements - Ensure that you have the following MATLAB toolboxes installed:<br />

MATLAB App Designer<br />

Signal Processing Toolbox<br />

Audio Toolbox<br />
## License
This project is licensed under the MIT License.

## Postscriptum 
The original code was created in June 2024.<br />
The app was a part Signal Processing subject.