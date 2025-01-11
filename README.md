# Electromagnetism Solver

## Overview

**Electromagnetism Solver** is a Flutter-based mobile application designed to assist students in solving basic electromagnetism problems. This application supports calculations for formulas such as Magnetic Flux Integral and Induced EMF in a loop. 

---

## Features

- **Formula Selection**: Choose from a list of predefined formulas:
  - Magnetic Flux Integral (ΦB = ∫∫B·dS)
  - Induced EMF in a loop (E = - dΦB/dt)
- **Dynamic Input Fields**: Enter variables for the selected formula, including numbers and directions.
- **Real-Time Calculation**: Results are updated instantly upon input.
- **Symbolic Calculation**: Supports symbolic substitution and formatting of equations with subscripts and superscripts.
- **Clear Functionality**: Clear all input fields and reset the result.

---

## Requirements

- **Flutter SDK**: Version 3.0 or above
- **Dart**: Version 2.18 or above
- **IDE**: Android Studio, Visual Studio Code, or IntelliJ IDEA with Flutter plugin
- **Device**: Android or iOS device/emulator

---

## Getting Started
### 1. Clone the Repository
```bash
git clone https://github.com/SharonLZX/Electro-Magnetism-Solver.git
```

### 2. Change current directory
```bash
cd Electro-Magnetism-Solver
```
### 3.Install dependencies
```bash
flutter pub get
```

### 4.Run the application
Connect a device (through USB) or emulator and execute:
```bash
flutter run
```

---
## Usage
1. Launch the app.
2. Select a formula of choice from the dropdown menu.
3. Fill in the required input fields:

    **Magnetic Flux Integral**: 
    Magnetic field strength (B), Field direction (BD), surface area(S) and Surface direction (SD).

    **Induced EMF:**
    Change in magnetic flux (dΦB) and time (dt).

4. Press **calculate** button to compute the result.

5. To reset inputs and results, press the **clear** button.

---

## Code Structure
#### main.dart:

Contains the application logic.

#### Helper functions:
1) User interface:
    - defaultForm() - Special characters disallowed.
    - directionForm() - Only ***(ax, ay, az)*** allowed.
    - numberForm() - Only numbers allowed.


2) Calculations:
    - magneticFluxIntegral() - ΦB = ∫∫B·dS
    - inducedEMFLoop() - E = - dΦB/dt
    - subscriptFormatting() - Handles subscript formatting.
    - _convertToSubscript() - Converts numbers to subscript
    - _convertToSuperscript() - Convert numbers to superscript
    - multiplySymbolic() - Handles unneccsary formatting ***(e.g. C*1 = C)***
    - magneticFluxIntegralSymbolic() - 
    - calculateResult() - Main calculation manager
    - clearFields() - Clears TextEditingController

---

## License
This project is licensed under the MIT License. See the LICENSE file for details.



