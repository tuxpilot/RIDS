#define MQ2pin (A0)
float MQ2Value;  //variable to store sensor value

const int MQ7pin=8;
float MQ7Value;  //variable to store sensor value

#include "DHT.h" // include the DHT library

#define DHTPIN 2 // define the Digital pin used by the DHT11
#define DHTTYPE DHT11 // Defining the DHT model which is used
DHT dht(DHTPIN, DHTTYPE); // We define the DHT with all its parameters

void setup()
{
  Serial.begin(9600); // sets the serial port to 9600
  Serial.println("Gas sensor setting up.");
  delay(10000); // allow the MQ-2 to set up and get ready
  dht.begin(); // setting up the DHT11
}

void loop()
{
  MQ2Value = analogRead(MQ2pin); // reading the input pin analog 0 (A0)
  MQ7Value = analogRead(MQ7pin); // reading the input pin analog 1 (A1)
  Serial.print("MQ2_Value: ");
  Serial.print(MQ2Value);
  Serial.println("");
  Serial.print("MQ7_Value: ");
  Serial.print(MQ7Value);
  Serial.println("");
  Serial.println("DHT11_Temperature: " + String(dht.readTemperature())); // The value is in Celsius degrees
  Serial.println("DHT11_Humidity: " + String(dht.readHumidity())); // The value is in %age
  delay(2000); // wait 2s for next reading
}
