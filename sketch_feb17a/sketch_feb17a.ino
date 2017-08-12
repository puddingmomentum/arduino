#include <pins_arduino.h>


volatile byte punched = 0;
const char* msg = "Sensor activated";

void setup() {
  Serial.begin(9600);
  Serial.println("PinChangeInt test on pins A0 - A5 ");
  for (int i=A0; i<=A5; i++) {
    Serial.println(i);
    pciSetup(i);
  }
}

void loop() {
  // put your main code here, to run repeatedly:
  if (punched) {
    punched = 0;
    // triggerMusic();
    Serial.println(msg);
  }
}

void pciSetup(byte pin)
{
  *digitalPinToPCMSK(pin) |= bit(digitalPinToPCMSKbit(pin)); //enable pin
  PCIFR |= bit(digitalPinToPCICRbit(pin)); // clear any outstanding interrupt
  PCIFR |= bit(digitalPinToPCICRbit(pin)); // enable interrupt for the group
}

// Use oneroutine to handle each group

ISR(PCINT1_vect) // handle pin change interrupt for A0 to A5 here
{
  punched = 1;
}

void triggerMusic()
{
  Serial.println(msg);
}

