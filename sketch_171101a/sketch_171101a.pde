import processing.serial.*;

Serial myPort;
String val;

void setup () {
  // Assume Arduino is connected to COM1
  String portname = Serial.list()[0]; // change 0 to match correct port
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  while (myPort.available() > 0) {
    int inByte = myPort.read();