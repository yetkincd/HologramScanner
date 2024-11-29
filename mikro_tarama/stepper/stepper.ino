#include <X113647Stepper.h>
int x = 4;
tardate::X113647Stepper stepmotor(x, 8, 9, 10, 11);
void setup() {
  stepmotor.setSpeed(1000);
  Serial.begin(9600);
}

void loop() {
  if (Serial.available() > 0) {
    int t = Serial.read();
    if (t != -1) {
      Serial.println("-");
      stepmotor.step(x);
    }
  }
}