#define MQ2pin (0)

float MQ2Value;  //variable to store sensor value

void setup()
{
  Serial.begin(9600); // sets the serial port to 9600
  Serial.println("Gas sensor setting up.");
  delay(20000); // allow the MQ-2 to set up and get ready
}

void loop()
{
  MQ2Value = analogRead(MQ2pin); // reading the input pin analog 0 (A0)
  
  Serial.print("MQ2 Value: ");
  Serial.print(MQ2Value);
  
 
  Serial.println("");
  delay(2000); // wait 2s for next reading
}
