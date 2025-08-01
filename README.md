🔐 Safe with Unique Unlocking

An innovative security system that unlocks using light-based signals, combining hardware and software technologies for a futuristic access experience.

---

📖 Project Overview

This project showcases a custom-built safe that unlocks via a unique light pattern detected by a photoresistor. Instead of traditional passwords or keys, the unlocking mechanism relies on timed pulses of light generated by a mobile application. If the received signal matches the stored pattern, access is granted via a solenoid mechanism.

Built using Arduino, EEPROM memory, Flutter-based app, and principles inspired by Li-Fi technology, this safe offers multi-layered security and a modern approach to access control.

---

🛠️ Technologies Used

- Arduino Nano – microcontroller for managing signal detection and control
- Photoresistor (LDR) – detects light signals
- Solenoid Lock – opens when the correct signal is received
- EEPROM – stores up to 3 unique light patterns
- Flutter App – sends encoded light signals to the safe

---

🚀 How It Works

1. The app sends a light pattern to the photoresistor.
2. The Arduino reads the signal's timing and compares it with saved patterns.
3. If there's a match, the solenoid unlocks the safe for 5 seconds.
4. If it's a new signal and memory isn't full, it gets saved as a new pattern.
