//recepcion de datos por serial

int led = 13;
char val;         // variable to receive data from the serial port
String data = "";

void setup() 
{
  Serial.begin(9600);       // start serial communication at 9600bps
  pinMode(led, OUTPUT);
}

void loop() {
  if( Serial.available() )  // if data is available to read
  {
    val = Serial.read();    // read it and store it in 'val'
    if( val == 'A' ) {      // if not an 'L'
      digitalWrite(led, HIGH);
    } else if(val == 'B'){
      digitalWrite(led, LOW);
    }
    delay(100);
  }
}

