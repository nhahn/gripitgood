void setup() {
   // Open serial communications and wait for port to open:
   Serial.begin(115200);
   Serial1.begin(38400);
}
void loop() {
   if (Serial1.available())
      Serial.write(Serial1.read());
   if (Serial.available()) {
      byte in = Serial.read();
      Serial.write(in); // local echo
      Serial1.write(in);
   }
}
