
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  //int a0,a1,a2,a3,a4,a5 = 0;
  int total = 0;
  int apins[6];
  for (int i = 0; i < 6; i++) {
    apins[i] = analogRead(i);
    total += apins[i];
  }

  if (total > 0) {Serial.println(total);}
}
