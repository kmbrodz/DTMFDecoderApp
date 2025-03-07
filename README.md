# DTMFDecoderApp
![MATLAB](https://img.shields.io/badge/Built%20with-MATLAB-blue?style=for-the-badge&logo=mathworks)  
The **DTMF Decoder App** is a MATLAB-based application that decodes **Dual-Tone Multi-Frequency (DTMF) signals**.  

## 🎥 Example 
A demonstration of how the app works is available in the project repository: **`HowTheAppWorks.mp4`**  

## 🏗️ Overview

- The code records an **audio signal** from the computer’s built-in microphone.  
- It analyzes its **frequency components** using **FFT** and filtering.  
- Then, it decodes the signal into **DTMF (Dual-Tone Multi-Frequency) tones**.
<br />

- **Classical approach** to tone recognition.  
- The app can **decode 16 digits**:  
   `1, 2, 3, 4, 5, 6, 7, 8, 9, *, 0, #, A, B, C, D`  
- Each digit on a telephone keypad is encoded using a combination of **two specific frequencies**.  
## 🛠 Usage

Run the **DTMFDecoderApp.m** script to launch the application.<br />
Click the 'Start' button to begin recording.<br />
The app will display:<br />

-The recorded signal in the time domain.<br />

-The frequency spectrum of the recorded audio.<br />

-The decoded digits.<br />
<br />
Requirements - Ensure that you have the following MATLAB toolboxes installed:<br />

**MATLAB App Designer**<br />

**Signal Processing Toolbox**<br />

**Audio Toolbox**<br />
## 📝 License
This project is licensed under the MIT License.

## Postscriptum 
The original code was created in June 2024.<br />
The app was a part Signal Processing subject.
