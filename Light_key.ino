
#define Solenoid 2 
#define ldr A0     
#include <EEPROM.h>

int threshold = 220;      
int tolerance = 100;      
int receivedPattern[5];  
int storedPattern[3][5];  // Запазваме до 3 сигнала, всеки с дължина 5
int currentIndex = 0;     
int signalCount = 0; // Брояч за сигналите
const int maxSignals = 3;  // Максимален брой сигнали

void setup() {
  Serial.begin(9600);
  pinMode(Solenoid, OUTPUT);
  digitalWrite(Solenoid, HIGH);
  loadStoredPatterns(); // Четене на запаметените шаблони от EEPROM
}

void loop() {
  int val = analogRead(ldr);
  bool lightDetected = (val < threshold);

  if (lightDetected) {
    unsigned long startTime = millis();

    // Блокиране на цикъла докато светлината не изчезне
    while (analogRead(ldr) < threshold);
    unsigned long endTime = millis();

    int duration = endTime - startTime;

    if (currentIndex < 5) {
      receivedPattern[currentIndex++] = duration; 
    }

    // Когато получим целия шаблон
    if (currentIndex == 5) {
      bool matchFound = false;
      for (int i = 0; i < maxSignals; i++) {
        if (isEqual(receivedPattern, storedPattern[i])) {
          matchFound = true;
          break;
        }
      }

      if (matchFound) {
        Serial.println("Шаблонът съвпадна! Активиране на соленоида.");
        digitalWrite(Solenoid, LOW); 
        delay(5000);               
        digitalWrite(Solenoid, HIGH);
      } else if (signalCount < maxSignals) {
        Serial.println("Запаметяване на новия шаблон в EEPROM.");
        savePattern(receivedPattern);
      } else {
        Serial.println("Максимален брой шаблони е достигнат. Новият шаблон няма да бъде запаметен.");
      }

      // Рестартиране на индекса за следващото измерване
      currentIndex = 0;
    }
  } else {
    // Ако светлината не се открива, може да се добави малко време за обработка
    delay(50);  // Малка пауза, за да не се блокира цикълът
  }
}

void savePattern(int pattern[]) {
  int saveIndex = signalCount % maxSignals;
  for (int i = 0; i < 5; i++) {
    storedPattern[saveIndex][i] = pattern[i];
    EEPROM.put(saveIndex * 5 * sizeof(int) + i * sizeof(int), storedPattern[saveIndex][i]);
  }
  signalCount++;
  if (signalCount > maxSignals) {
    signalCount = maxSignals; // Ограничаване на брояча на сигналите
  }
  EEPROM.write(maxSignals * 5 * sizeof(int), signalCount); // Запис на брояча на сигналите
}

void loadStoredPatterns() {
  for (int i = 0; i < maxSignals; i++) {
    for (int j = 0; j < 5; j++) {
      EEPROM.get(i * 5 * sizeof(int) + j * sizeof(int), storedPattern[i][j]);
    }
  }
  signalCount = EEPROM.read(maxSignals * 5 * sizeof(int)); // Четене на брояча на сигналите
}

bool isEqual(int pattern1[], int pattern2[]) {
  for (int i = 0; i < 5; i++) {
    if (abs(pattern1[i] - pattern2[i]) > tolerance) {
      return false;
    }
  }
  return true;
}



/*
#include <EEPROM.h>

void clearEEPROM() {
  for (int i = 0; i < EEPROM.length(); i++) {
    EEPROM.write(i, 0);  // Записва 0 във всяка клетка от EEPROM паметта
  }
}

void setup() {
  Serial.begin(9600);
  Serial.println("Изчистване на EEPROM паметта...");
  clearEEPROM();
  Serial.println("EEPROM паметта е изчистена.");
}

void loop() {
  // Основният цикъл остава празен
}
*/