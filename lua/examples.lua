local examples = {}

examples.p06_LightTheremin = [[

/*
  Arduino Starter Kit example
  Project 6 - Light Theremin

  This sketch is written to accompany Project 6 in the Arduino Starter Kit

  Parts required:
  - photoresistor
  - 10 kilohm resistor
  - piezo

  created 13 Sep 2012
  by Scott Fitzgerald

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

// variable to hold sensor value
int sensorValue;
// variable to calibrate low value
int sensorLow = 1023;
// variable to calibrate high value
int sensorHigh = 0;
// LED pin
const int ledPin = 13;

void setup() {
  // Make the LED pin an output and turn it on
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);

  // calibrate for the first five seconds after program runs
  while (millis() < 5000) {
    // record the maximum sensor value
    sensorValue = analogRead(A0);
    if (sensorValue > sensorHigh) {
      sensorHigh = sensorValue;
    }
    // record the minimum sensor value
    if (sensorValue < sensorLow) {
      sensorLow = sensorValue;
    }
  }
  // turn the LED off, signaling the end of the calibration period
  digitalWrite(ledPin, LOW);
}

void loop() {
  //read the input from A0 and store it in a variable
  sensorValue = analogRead(A0);

  // map the sensor values to a wide range of pitches
  int pitch = map(sensorValue, sensorLow, sensorHigh, 50, 4000);

  // play the tone for 20 ms on pin 8
  tone(8, pitch, 20);

  // wait for a moment
  delay(10);
}

]]


examples.switchCase2 = [[

/*
  Switch statement with serial input

  Demonstrates the use of a switch statement. The switch statement allows you
  to choose from among a set of discrete values of a variable. It's like a
  series of if statements.

  To see this sketch in action, open the Serial monitor and send any character.
  The characters a, b, c, d, and e, will turn on LEDs. Any other character will
  turn the LEDs off.

  The circuit:
  - five LEDs attached to digital pins 2 through 6 through 220 ohm resistors

  created 1 Jul 2009
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/control-structures/SwitchCase2/
*/

void setup() {
  // initialize serial communication:
  Serial.begin(9600);
  // initialize the LED pins:
  for (int thisPin = 2; thisPin < 7; thisPin++) {
    pinMode(thisPin, OUTPUT);
  }
}

void loop() {
  // read the sensor:
  if (Serial.available() > 0) {
    int inByte = Serial.read();
    // do something different depending on the character received.
    // The switch statement expects single number values for each case; in this
    // example, though, you're using single quotes to tell the controller to get
    // the ASCII value for the character. For example 'a' = 97, 'b' = 98,
    // and so forth:

    switch (inByte) {
      case 'a':
        digitalWrite(2, HIGH);
        break;
      case 'b':
        digitalWrite(3, HIGH);
        break;
      case 'c':
        digitalWrite(4, HIGH);
        break;
      case 'd':
        digitalWrite(5, HIGH);
        break;
      case 'e':
        digitalWrite(6, HIGH);
        break;
      default:
        // turn all the LEDs off:
        for (int thisPin = 2; thisPin < 7; thisPin++) {
          digitalWrite(thisPin, LOW);
        }
    }
  }
}

]]


examples.switchCase = [[

/*
  Switch statement

  Demonstrates the use of a switch statement. The switch statement allows you
  to choose from among a set of discrete values of a variable. It's like a
  series of if statements.

  To see this sketch in action, put the board and sensor in a well-lit room,
  open the Serial Monitor, and move your hand gradually down over the sensor.

  The circuit:
  - photoresistor from analog in 0 to +5V
  - 10K resistor from analog in 0 to ground

  created 1 Jul 2009
  modified 9 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/control-structures/SwitchCase/
*/

// these constants won't change. They are the lowest and highest readings you
// get from your sensor:
const int sensorMin = 0;    // sensor minimum, discovered through experiment
const int sensorMax = 600;  // sensor maximum, discovered through experiment

void setup() {
  // initialize serial communication:
  Serial.begin(9600);
}

void loop() {
  // read the sensor:
  int sensorReading = analogRead(A0);
  // map the sensor range to a range of four options:
  int range = map(sensorReading, sensorMin, sensorMax, 0, 3);

  // do something different depending on the range value:
  switch (range) {
    case 0:  // your hand is on the sensor
      Serial.println("dark");
      break;
    case 1:  // your hand is close to the sensor
      Serial.println("dim");
      break;
    case 2:  // your hand is a few inches from the sensor
      Serial.println("medium");
      break;
    case 3:  // your hand is nowhere near the sensor
      Serial.println("bright");
      break;
  }
  delay(1);  // delay in between reads for stability
}

]]


examples.VirtualColorMixer = [[

/*
  This example reads three analog sensors (potentiometers are easiest) and sends
  their values serially. The Processing and Max/MSP programs at the bottom take
  those three values and use them to change the background color of the screen.

  The circuit:
  - potentiometers attached to analog inputs 0, 1, and 2

  created 2 Dec 2006
  by David A. Mellis
  modified 30 Aug 2011
  by Tom Igoe and Scott Fitzgerald

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/communication/VirtualColorMixer/
*/

const int redPin = A0;    // sensor to control red color
const int greenPin = A1;  // sensor to control green color
const int bluePin = A2;   // sensor to control blue color

void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.print(analogRead(redPin));
  Serial.print(",");
  Serial.print(analogRead(greenPin));
  Serial.print(",");
  Serial.println(analogRead(bluePin));
}

/* Processing code for this example

  // This example code is in the public domain.

  import processing.serial.*;

  float redValue = 0;        // red value
  float greenValue = 0;      // green value
  float blueValue = 0;       // blue value

  Serial myPort;

  void setup() {
    size(200, 200);

    // List all the available serial ports
    // if using Processing 2.1 or later, use Serial.printArray()
    println(Serial.list());

    // I know that the first port in the serial list on my Mac is always my
    // Arduino, so I open Serial.list()[0].
    // Open whatever port is the one you're using.
    myPort = new Serial(this, Serial.list()[0], 9600);
    // don't generate a serialEvent() unless you get a newline character:
    myPort.bufferUntil('\n');
  }

  void draw() {
    // set the background color with the color values:
    background(redValue, greenValue, blueValue);
  }

  void serialEvent(Serial myPort) {
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');

    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      // split the string on the commas and convert the resulting substrings
      // into an integer array:
      float[] colors = float(split(inString, ","));
      // if the array has at least three elements, you know you got the whole
      // thing.  Put the numbers in the color variables:
      if (colors.length >= 3) {
        // map them to the range 0-255:
        redValue = map(colors[0], 0, 1023, 0, 255);
        greenValue = map(colors[1], 0, 1023, 0, 255);
        blueValue = map(colors[2], 0, 1023, 0, 255);
      }
    }
  }

*/

/* Max/MSP patch for this example

  ----------begin_max5_patcher----------
  1512.3oc4Z00aaaCE8YmeED9ktB35xOjrj1aAsXX4g8xZQeYoXfVh1gqRjdT
  TsIsn+2K+PJUovVVJ1VMdCAvxThV7bO7b48dIyWtXxzkxaYkSA+J3u.Sl7kK
  lLwcK6MlT2dxzB5so4zRW2lJXeRt7elNy+HM6Vs61uDDzbOYkNmo02sg4euS
  4BSede8S2P0o2vEq+aEKU66PPP7b3LPHDauPvyCmAvv4v6+M7L2XXF2WfCaF
  lURgVPKbCxzKUbZdySDUEbgABN.ia08R9mccGYGn66qGutNir27qWbg8iY+7
  HDRx.Hjf+OPHCQgPdpQHoxhBlwB+QF4cbkthlCRk4REnfeKScs3ZwaugWBbj
  .PS+.qDPAkZkgPlY5oPS4By2A5aTLFv9pounjsgpnZVF3x27pqtBrRpJnZaa
  C3WxTkfUJYA.BzR.BhIy.ehquw7dSoJCsrlATLckR.nhLPNWvVwL+Vp1LHL.
  SjMG.tRaG7OxT5R2c8Hx9B8.wLCxVaGI6qnpj45Ug84kL+6YIM8CqUxJyycF
  7bqsBRULGvwfWyRMyovElat7NvqoejaLm4f+fkmyKuVTHy3q3ldhB.WtQY6Z
  x0BSOeSpTqA+FW+Yy3SyybH3sFy8p0RVCmaMpTyX6HdDZ2JsPbfSogbBMueH
  JLd6RMBdfRMzPjZvimuWIK2XgFA.ZmtfKoh0Sm88qc6OF4bDQ3P6kEtF6xej
  .OkjD4H5OllyS+.3FlhY0so4xRlWqyrXErQpt+2rsnXgQNZHZgmMVzEofW7T
  S4zORQtgIdDbRHrObRzSMNofUVZVcbKbhQZrSOo934TqRHIN2ncr7BF8TKR1
  tHDqL.PejLRRPKMR.pKFAkbtDa+UOvsYsIFH0DYsTCjqZ66T1CmGeDILLpSm
  myk0SdkOKh5LUr4GbWwRYdW7fm.BvDmzHnSdH3biGpSbxxDNJoGDAD1ChH7L
  I0DaloOTBLvkO7zPs5HJnKNoGAXbol5eytUhfyiSfnjE1uAq+Fp0a+wygGwR
  q3ZI8.psJpkpJnyPzwmXBj7Sh.+bNvVZxlcKAm0OYHIxcIjzEKdRChgO5UMf
  LkMPNN0MfiS7Ev6TYQct.F5IWcCZ4504rGsiVswGWWSYyma01QcZgmL+f+sf
  oU18Hn6o6dXkMkFF14TL9rIAWE+6wvGV.p.TPqz3HK5L+VxYxl4UmBKEjr.B
  6zinuKI3C+D2Y7azIM6N7QL6t+jQyZxymK1ToAKqVsxjlGyjz2c1kTK3180h
  kJEYkacWpv6lyp2VJTjWK47wHA6fyBOWxH9pUf6jUtZkLpNKW.9EeUBH3ymY
  XSQlaqGrkQMGzp20adYSmIOGjIABo1xZyAWJtCX9tg6+HMuhMCPyx76ao+Us
  UxmzUE79H8d2ZB1m1ztbnOa1mGeAq0awyK8a9UqBUc6pZolpzurTK232e5gp
  aInVw8QIIcpaiNSJfY4Z+92Cs+Mc+mgg2cEsvGlLY6V+1kMuioxnB5VM+fsY
  9vSu4WI1PMBGXye6KXvNuzmZTh7U9h5j6vvASdngPdgOFxycNL6ia1axUMmT
  JIzebXcQCn3SKMf+4QCMmOZung+6xBCPLfwO8ngcEI52YJ1y7mx3CN9xKUYU
  bg7Y1yXjlKW6SrZnguQdsSfOSSDItqv2jwJFjavc1vO7OigyBr2+gDYorRk1
  HXZpVFfu2FxXkZtfp4RQqNkX5y2sya3YYL2iavWAOaizH+pw.Ibg8f1I9h3Z
  2B79sNeOHvBOtfEalWsvyu0KMf015.AaROvZ7vv5AhnndfHLbTgjcCK1KlHv
  gOk5B26OqrXjcJ005.QqCHn8fVTxnxfj93SfQiJlv8YV0VT9fVUwOOhSV3uD
  eeqCUClbBPa.j3vWDoMZssNTzRNEnE6gYPXazZaMF921syaLWyAeBXvCESA8
  ASi6Zyw8.RQi65J8ZsNx3ho93OhGWENtWpowepae4YhCFeLErOLENtXJrOSc
  iadi39rf4hwc8xdhHz3gn3dBI7iDRlFe8huAfIZhq
  -----------end_max5_patcher-----------

*/

]]


examples.p14_TweakTheArduinoLogo = [[

/*
  Arduino Starter Kit example
  Project 14 - Tweak the Arduino Logo

  This sketch is written to accompany Project 14 in the Arduino Starter Kit

  Parts required:
  - 10 kilohm potentiometer

  Software required:
  - Processing (3.0 or newer) https://processing.org/
  - Active Internet connection

  created 18 Sep 2012
  by Scott Fitzgerald

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/


void setup() {
  // initialize serial communication
  Serial.begin(9600);
}

void loop() {
  // read the value of A0, divide by 4 and send it as a byte over the
  // serial connection
  Serial.write(analogRead(A0) / 4);
  delay(1);
}

/* Processing code for this example

  // Tweak the Arduino Logo

  // by Scott Fitzgerald
  // This example code is in the public domain.

  // import the serial library
  import processing.serial.*;

  // create an instance of the serial library
  Serial myPort;

  // create an instance of PImage
  PImage logo;

  // a variable to hold the background color
  int bgcolor = 0;

  void setup() {
    size(1, 1);
    surface.setResizable(true);
    // set the color mode to Hue/Saturation/Brightness
    colorMode(HSB, 255);

    // load the Arduino logo into the PImage instance
    logo = loadImage("http://www.arduino.cc/arduino_logo.png");

    // make the window the same size as the image
    surface.setSize(logo.width, logo.height);

    // print a list of available serial ports to the Processing status window
    println("Available serial ports:");
    println(Serial.list());

    // Tell the serial object the information it needs to communicate with the
    // Arduino. Change Serial.list()[0] to the correct port corresponding to
    // your Arduino board.  The last parameter (e.g. 9600) is the speed of the
    // communication.  It has to correspond to the value passed to
    // Serial.begin() in your Arduino sketch.
    myPort = new Serial(this, Serial.list()[0], 9600);

    // If you know the name of the port used by the Arduino board, you can
    // specify it directly like this.
    // port = new Serial(this, "COM1", 9600);
  }

  void draw() {

    // if there is information in the serial port
    if ( myPort.available() > 0) {
      // read the value and store it in a variable
      bgcolor = myPort.read();

      // print the value to the status window
      println(bgcolor);
    }

    // Draw the background. the variable bgcolor contains the Hue, determined by
    // the value from the serial port
    background(bgcolor, 255, 255);

    // draw the Arduino logo
    image(logo, 0, 0);
  }

*/

]]


examples.toneMelody = [[

/*
  Melody

  Plays a melody

  circuit:
  - 8 ohm speaker on digital pin 8

  created 21 Jan 2010
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/digital/toneMelody/
*/

#include "pitches.h"

// notes in the melody:
int melody[] = {
  NOTE_C4, NOTE_G3, NOTE_G3, NOTE_A3, NOTE_G3, 0, NOTE_B3, NOTE_C4
};

// note durations: 4 = quarter note, 8 = eighth note, etc.:
int noteDurations[] = {
  4, 8, 8, 4, 4, 4, 4, 4
};

void setup() {
  // iterate over the notes of the melody:
  for (int thisNote = 0; thisNote < 8; thisNote++) {

    // to calculate the note duration, take one second divided by the note type.
    //e.g. quarter note = 1000 / 4, eighth note = 1000/8, etc.
    int noteDuration = 1000 / noteDurations[thisNote];
    tone(8, melody[thisNote], noteDuration);

    // to distinguish the notes, set a minimum time between them.
    // the note's duration + 30% seems to work well:
    int pauseBetweenNotes = noteDuration * 1.30;
    delay(pauseBetweenNotes);
    // stop the tone playing:
    noTone(8);
  }
}

void loop() {
  // no need to repeat the melody.
}

]]


examples.p12_KnockLock = [[

/*
  Arduino Starter Kit example
  Project 12 - Knock Lock

  This sketch is written to accompany Project 12 in the Arduino Starter Kit

  Parts required:
  - 1 megohm resistor
  - 10 kilohm resistor
  - three 220 ohm resistors
  - piezo
  - servo motor
  - push button
  - one red LED
  - one yellow LED
  - one green LED
  - 100 uF capacitor

  created 18 Sep 2012
  by Scott Fitzgerald
  Thanks to Federico Vanzati for improvements

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

// import the library
#include <Servo.h>
// create an instance of the Servo library
Servo myServo;

const int piezo = A0;     // pin the piezo is attached to
const int switchPin = 2;  // pin the switch is attached to
const int yellowLed = 3;  // pin the yellow LED is attached to
const int greenLed = 4;   // pin the green LED is attached to
const int redLed = 5;     // pin the red LED is attached to

// variable for the piezo value
int knockVal;
// variable for the switch value
int switchVal;

// variables for the high and low limits of the knock value
const int quietKnock = 10;
const int loudKnock = 100;

// variable to indicate if locked or not
bool locked = false;
// how many valid knocks you've received
int numberOfKnocks = 0;

void setup() {
  // attach the servo to pin 9
  myServo.attach(9);

  // make the LED pins outputs
  pinMode(yellowLed, OUTPUT);
  pinMode(redLed, OUTPUT);
  pinMode(greenLed, OUTPUT);

  // set the switch pin as an input
  pinMode(switchPin, INPUT);

  // start serial communication for debugging
  Serial.begin(9600);

  // turn the green LED on
  digitalWrite(greenLed, HIGH);

  // move the servo to the unlocked position
  myServo.write(0);

  // print status to the Serial Monitor
  Serial.println("the box is unlocked!");
}

void loop() {

  // if the box is unlocked
  if (locked == false) {

    // read the value of the switch pin
    switchVal = digitalRead(switchPin);

    // if the button is pressed, lock the box
    if (switchVal == HIGH) {
      // set the locked variable to "true"
      locked = true;

      // change the status LEDs
      digitalWrite(greenLed, LOW);
      digitalWrite(redLed, HIGH);

      // move the servo to the locked position
      myServo.write(90);

      // print out status
      Serial.println("the box is locked!");

      // wait for the servo to move into position
      delay(1000);
    }
  }

  // if the box is locked
  if (locked == true) {

    // check the value of the piezo
    knockVal = analogRead(piezo);

    // if there are not enough valid knocks
    if (numberOfKnocks < 3 && knockVal > 0) {

      // check to see if the knock is in range
      if (checkForKnock(knockVal) == true) {

        // increment the number of valid knocks
        numberOfKnocks++;
      }

      // print status of knocks
      Serial.print(3 - numberOfKnocks);
      Serial.println(" more knocks to go");
    }

    // if there are three knocks
    if (numberOfKnocks >= 3) {
      // unlock the box
      locked = false;

      // move the servo to the unlocked position
      myServo.write(0);

      // wait for it to move
      delay(20);

      // change status LEDs
      digitalWrite(greenLed, HIGH);
      digitalWrite(redLed, LOW);
      Serial.println("the box is unlocked!");

      numberOfKnocks = 0;
    }
  }
}

// this function checks to see if a detected knock is within max and min range
bool checkForKnock(int value) {
  // if the value of the knock is greater than the minimum, and larger
  // than the maximum
  if (value > quietKnock && value < loudKnock) {
    // turn the status LED on
    digitalWrite(yellowLed, HIGH);
    delay(50);
    digitalWrite(yellowLed, LOW);
    // print out the status
    Serial.print("Valid knock of value ");
    Serial.println(value);
    // return true
    return true;
  }
  // if the knock is not within range
  else {
    // print status
    Serial.print("Bad knock value ");
    Serial.println(value);
    // return false
    return false;
  }
}

]]


examples.DigitalReadSerial = [[

/*
  DigitalReadSerial

  Reads a digital input on pin 2, prints the result to the Serial Monitor

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/basics/DigitalReadSerial/
*/

// digital pin 2 has a pushbutton attached to it. Give it a name:
int pushButton = 2;

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  // make the pushbutton's pin an input:
  pinMode(pushButton, INPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input pin:
  int buttonState = digitalRead(pushButton);
  // print out the state of the button:
  Serial.println(buttonState);
  delay(1);  // delay in between reads for stability
}

]]


examples.WhileStatementConditional = [[

/*
  Conditionals - while statement

  This example demonstrates the use of  while() statements.

  While the pushbutton is pressed, the sketch runs the calibration routine.
  The sensor readings during the while loop define the minimum and maximum of
  expected values from the photoresistor.

  This is a variation on the calibrate example.

  The circuit:
  - photoresistor connected from +5V to analog in pin 0
  - 10 kilohm resistor connected from ground to analog in pin 0
  - LED connected from digital pin 9 to ground through 220 ohm resistor
  - pushbutton attached from pin 2 to +5V
  - 10 kilohm resistor attached from pin 2 to ground

  created 17 Jan 2009
  modified 30 Aug 2011
  by Tom Igoe
  modified 20 Jan 2017
  by Arturo Guadalupi

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/control-structures/WhileStatementConditional/
*/


// These constants won't change:
const int sensorPin = A0;        // pin that the sensor is attached to
const int ledPin = 9;            // pin that the LED is attached to
const int indicatorLedPin = 13;  // pin that the built-in LED is attached to
const int buttonPin = 2;         // pin that the button is attached to


// These variables will change:
int sensorMin = 1023;  // minimum sensor value
int sensorMax = 0;     // maximum sensor value
int sensorValue = 0;   // the sensor value


void setup() {
  // set the LED pins as outputs and the switch pin as input:
  pinMode(indicatorLedPin, OUTPUT);
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT);
}

void loop() {
  // while the button is pressed, take calibration readings:
  while (digitalRead(buttonPin) == HIGH) {
    calibrate();
  }
  // signal the end of the calibration period
  digitalWrite(indicatorLedPin, LOW);

  // read the sensor:
  sensorValue = analogRead(sensorPin);

  // apply the calibration to the sensor reading
  sensorValue = map(sensorValue, sensorMin, sensorMax, 0, 255);

  // in case the sensor value is outside the range seen during calibration
  sensorValue = constrain(sensorValue, 0, 255);

  // fade the LED using the calibrated value:
  analogWrite(ledPin, sensorValue);
}

void calibrate() {
  // turn on the indicator LED to indicate that calibration is happening:
  digitalWrite(indicatorLedPin, HIGH);
  // read the sensor:
  sensorValue = analogRead(sensorPin);

  // record the maximum sensor value
  if (sensorValue > sensorMax) {
    sensorMax = sensorValue;
  }

  // record the minimum sensor value
  if (sensorValue < sensorMin) {
    sensorMin = sensorValue;
  }
}

]]


examples.Ping = [[

/*
  Ping))) Sensor

  This sketch reads a PING))) ultrasonic rangefinder and returns the distance
  to the closest object in range. To do this, it sends a pulse to the sensor to
  initiate a reading, then listens for a pulse to return. The length of the
  returning pulse is proportional to the distance of the object from the sensor.

  The circuit:
	- +V connection of the PING))) attached to +5V
	- GND connection of the PING))) attached to ground
	- SIG connection of the PING))) attached to digital pin 7

  created 3 Nov 2008
  by David A. Mellis
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/sensors/Ping/
*/

// this constant won't change. It's the pin number of the sensor's output:
const int pingPin = 7;

void setup() {
  // initialize serial communication:
  Serial.begin(9600);
}

void loop() {
  // establish variables for duration of the ping, and the distance result
  // in inches and centimeters:
  long duration, inches, cm;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH pulse
  // whose duration is the time (in microseconds) from the sending of the ping
  // to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);

  // convert the time into a distance
  inches = microsecondsToInches(duration);
  cm = microsecondsToCentimeters(duration);

  Serial.print(inches);
  Serial.print("in, ");
  Serial.print(cm);
  Serial.print("cm");
  Serial.println();

  delay(100);
}

long microsecondsToInches(long microseconds) {
  // According to Parallax's datasheet for the PING))), there are 73.746
  // microseconds per inch (i.e. sound travels at 1130 feet per second).
  // This gives the distance travelled by the ping, outbound and return,
  // so we divide by 2 to get the distance of the obstacle.
  // See: https://www.parallax.com/package/ping-ultrasonic-distance-sensor-downloads/
  return microseconds / 74 / 2;
}

long microsecondsToCentimeters(long microseconds) {
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the object we
  // take half of the distance travelled.
  return microseconds / 29 / 2;
}

]]


examples.SerialCallResponse = [[

/*
  Serial Call and Response
  Language: Wiring/Arduino

  This program sends an ASCII A (byte of value 65) on startup and repeats that
  until it gets some data in. Then it waits for a byte in the serial port, and
  sends three sensor values whenever it gets a byte in.

  The circuit:
  - potentiometers attached to analog inputs 0 and 1
  - pushbutton attached to digital I/O 2

  created 26 Sep 2005
  by Tom Igoe
  modified 24 Apr 2012
  by Tom Igoe and Scott Fitzgerald
  Thanks to Greg Shakar and Scott Fitzgerald for the improvements

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/communication/SerialCallResponse/
*/

int firstSensor = 0;   // first analog sensor
int secondSensor = 0;  // second analog sensor
int thirdSensor = 0;   // digital sensor
int inByte = 0;        // incoming serial byte

void setup() {
  // start serial port at 9600 bps:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  pinMode(2, INPUT);   // digital sensor is on digital pin 2
  establishContact();  // send a byte to establish contact until receiver responds
}

void loop() {
  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    // read first analog input, divide by 4 to make the range 0-255:
    firstSensor = analogRead(A0) / 4;
    // delay 10ms to let the ADC recover:
    delay(10);
    // read second analog input, divide by 4 to make the range 0-255:
    secondSensor = analogRead(1) / 4;
    // read switch, map it to 0 or 255L
    thirdSensor = map(digitalRead(2), 0, 1, 0, 255);
    // send sensor values:
    Serial.write(firstSensor);
    Serial.write(secondSensor);
    Serial.write(thirdSensor);
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A');  // send a capital A
    delay(300);
  }
}

/* Processing sketch to run with this example:

  // This example code is in the public domain.

  import processing.serial.*;

  int bgcolor;           // Background color
  int fgcolor;           // Fill color
  Serial myPort;                       // The serial port
  int[] serialInArray = new int[3];    // Where we'll put what we receive
  int serialCount = 0;                 // A count of how many bytes we receive
  int xpos, ypos;                // Starting position of the ball
  boolean firstContact = false;        // Whether we've heard from the microcontroller

  void setup() {
    size(256, 256);  // Stage size
    noStroke();      // No border on the next thing drawn

    // Set the starting position of the ball (middle of the stage)
    xpos = width / 2;
    ypos = height / 2;

    // Print a list of the serial ports for debugging purposes
    // if using Processing 2.1 or later, use Serial.printArray()
    println(Serial.list());

    // I know that the first port in the serial list on my Mac is always my FTDI
    // adaptor, so I open Serial.list()[0].
    // On Windows machines, this generally opens COM1.
    // Open whatever port is the one you're using.
    String portName = Serial.list()[0];
    myPort = new Serial(this, portName, 9600);
  }

  void draw() {
    background(bgcolor);
    fill(fgcolor);
    // Draw the shape
    ellipse(xpos, ypos, 20, 20);
  }

  void serialEvent(Serial myPort) {
    // read a byte from the serial port:
    int inByte = myPort.read();
    // if this is the first byte received, and it's an A, clear the serial
    // buffer and note that you've had first contact from the microcontroller.
    // Otherwise, add the incoming byte to the array:
    if (firstContact == false) {
      if (inByte == 'A') {
        myPort.clear();          // clear the serial port buffer
        firstContact = true;     // you've had first contact from the microcontroller
        myPort.write('A');       // ask for more
      }
    }
    else {
      // Add the latest byte from the serial port to array:
      serialInArray[serialCount] = inByte;
      serialCount++;

      // If we have 3 bytes:
      if (serialCount > 2 ) {
        xpos = serialInArray[0];
        ypos = serialInArray[1];
        fgcolor = serialInArray[2];

        // print the values (for debugging purposes only):
        println(xpos + "\t" + ypos + "\t" + fgcolor);

        // Send a capital A to request new sensor readings:
        myPort.write('A');
        // Reset serialCount:
        serialCount = 0;
      }
    }
  }

*/

/* Max/MSP version 5 patch to run with this example:

  ----------begin_max5_patcher----------
  3908.3oc6ckziiaiE9b0+J3XjCIXpp.WzZNMURv.jCInQ5fYNjNngrDssRKK
  4nkp6JA4+973hrkrsjncKu0SRiXasQ83G+dKj7QV+4qtaxzrOxKlf9Zzuft6
  t+7U2cm7ThSbm936lrL3igIAExaaRJ+CYS+sI2qtTI+ikxSuBMKNojm+N3D4
  Aua5KkPwpuoUAkgKhSm+tbdXo5cQXVOhuGwrohuHD4WT7iXzupen3HY4BuqG
  rH0kzrrzxzfkb4kdJONHo9JoUKiSS3kRgjt4jYUk0mkznPJh+CYgHewpSqty
  xWVwUh3jIqkEYEfmqQEMr.ETbB+YddQbVZix+tIAqV03z203QDX4ukIKHm6W
  ep3T0ovqOUN+435m2Rcx+5U0E+FTzVBh9xOsHXIh5YuADg1x4IYgumG0r3mj
  shmFmtJmWvSKCJ0um0WNhOKnJo7c6GmZe8YAg7Ne381Rc2j44wQYoBgn0SJN
  c8qCHH1RhQqJi7NRCVsmGt.pGUESCxE31zDdCV.PRyxRZeo0MU.WOHMdYPIu
  LVIrT75BMd4p73zxVuHdZ.TFKJByyRRZUTpq77dtRDzZFx+PbT4BYY0DJgaO
  dUcSvj0XTT7bdQY6yUFLun8YZo71jl0TIt042RYNLa4RfCTWfsznKWDWfJpl
  tJHrbgV6t.AZInfzWP.4INpJHA8za91u+6QN1nk7hh.PpQwonxEbTAWzpilV
  MimilkmsDtPbo3TPiUdY0pGa9ZShS4gYUJz1pwE1iwCpxbAgJI9DGGwWNzFT
  ksLf3z7M0MybG6Hj1WngsD7VEXS8j5q7Wu5U0+39ir8QJJS5GMHdtRimL4m1
  0e1EVX0YsE2YssINriYRoFRyWVMoRRUGQvnkmms3pnXDYHbBKMPpIOL5i1s8
  3rMPwFcRCsGRyPH780.8HBnpWz.vlEQBWJ+0CSunehJSmJxiIZRtNGhhDYrU
  jt3ZQyA2fHJhZDifXIQHUHH8oGYgOREI5nqHIzhFWUndPyBdB3VzHJGwUhkV
  rgvRl2UCVNMHcd234lf1DN16HFEIdHt99A5hrp7v5WWMSBQZgMP.Tkwoqig8
  W1.Sn1f3h3nn1wLpBypPDzlJ7XinEGkLiMPloWOhrgR7dpZWJQV1faDy35Qj
  MThMFkWFGsJChQPqrQp8iorV6Q28HBVF4nMVDJj7f1xyYACFScisg.ruLHOW
  uMUS4Am4pI4PTnHi.6bi02HNzSYnDBe4cgAgKzRk1jc8PJLoH3Ydz6.Q.7K8
  tfxx73oUkJq1MGuCy5TpAi.POWZ3AenidLOOIaZPhdjZVW3sdk6LXEGzHb7p
  Mfr7SEy3SXHyBSxJ3J2ncNNYVJsXG6Me10nj4cfCRFdTFjLo7q3SiCpjjEDM
  .nvra.GN39.E2CDTHWXPo8.xzfqrHCHKnf5QUYUVdoZPUjCSC7LU8.XtTUXl
  X8vr51GjwFGLC2AlMdLkU4RiaRrnmJuiudnDk0ZW+9p6TuKBe433JUCzp6fU
  iOF0SUk2UQYUPNTEkiZubvKa1tsmgL5SCTXGHnnG0CceLpkpR9Rs28IUESWl
  EwWNKfHlg.zj6Ee7S+nE8A+m9F7Cu40u9gMm+aRp3kYYkKd3GDOz5y+c7b96
  K9gfvuIK68uNO6g2vUUL80WxihCVFD9vlB30e2SOrmxUb527RZ3nZNrljGrR
  70vs1J9suWuZ3zaHVdG3RIJLgGj2Gfn6TcGcstEfvtH.hpFLlnBndjOLGQAI
  z98BXc6yQxghmOn6gZqj0ShPOXhynLOjzCESt+XwE8TxrCvrdXo16rqnLgvb
  HaFmbh29QD+K0DyNdjDwvzQL.NXpoMvoOBxkger0HwMRQbpbCh91fjjG9Idw
  prTH9SzaSea5a.GQEPnnh43WNefMlsOgx18n.vgUNO.tKl7tDyI3iHzafJHZ
  VVNedVEbGgYIY42i93prB0i7B7KT1LnnCiyAiinpBnsPV7OG.tYKfBsrJOkG
  UG5aq26iJw6GyJ4eM5mEgEKaNQPMEBUp.t8.krplOVTlZdJAW27bjvGK7p2p
  HQPgLOSJDYv4E9gQBYBjMUselRxDy+4WplIzm9JQAWOEmfb.E364B43CAwp5
  uRRDEv8hWXprjADMUOYpOg9.bVQpEfhKgGCnAnk.rghBJCdTVICA3sDvAhE5
  oU4hf67ea5zWPuILqrD8uiK+i477fjHIt9y.V88yy3uMsZUj7wnxGKNAdPx5
  fAZMErDZOcJU4M01WFQokix.pKa+JE1WacmnKFeYd7b.0PeIzB8Kk+5WIZpB
  Ejt34KJeHgOCh4HK8Y3QiAkAfs8TRhhOkG7AAGQf0qxyfmQxa+PLb8Ex.2PS
  4BdO5GB9Hvg+cfJCMofAIMu9Qz+UPCjckqVJlEmyA8Bf.rC6.3hAEuG8TdTU
  bZljQ0nr1ayIqmTwQYfyRGafZhur5vfuyMSqYNWmtAPwWHalDSuUgT0Bosh.
  JpAR89Y6Ez5QEfPTQO4J0DHLInIliz8BZV2JfV3Bd36qsQwAVVXbr1BGXp6s
  Sd5sSDruo74wofx.HxUgxQwTnMLqTXvRmiGh2PUZr5pBynKChjl6feNUjSRn
  hEUfRPT1GfG9Ik4TQBm.hEZZ.bc38HjAMKGzDRijEm1ifx1dbgzQyKh6FZc3
  wOCkRJH+KUh0daWs6wzltWx1puXxlWW6NZWY2JiTBzzILRIANku02NourySM
  VI1VJTvQZff32AJr+dS9e34QAoA6EGXlGFH9yk7yyQAlVd3SR94g+TxOu1sU
  Flgd6ICI96LzazyPu1cgqsZ8r74SgF.65+efbMf4pGHT7lgHh30Sha3N5Ia.
  oqjMf7nsuMwycf7iYDybiAAVr3eC.oTMjpzEr8GDRc9bFRGHYXDrzg.Tlx+q
  NW8TY1IkzCfZ2IftkQstbB08HUezoDS+oFyI.cWIhWBaDiUo7qIrDO7f.L6n
  AXqCmyNT9act.z+Iv.GR0uES0ZXfjdz.IczAxQOUR+zvRsUTigRxmyPYeNlj
  yXv8Peef2ZFzuLzWPPeAE8ELzWXYlhe8WzAcUg+b1UkIoCLzIH60zwASGXau
  a1Dq2nUY.sox4vng+m0nACePngC9lEMLZMBPodOxf+yx5d4uMCTHm3kJvIIG
  jcLMedEQldkjpoBkQyjY1Hk.hmSY95Iwos8NDb9VSlIWOIntqgxryUjL6bCJ
  y1lli5tWWxrQ7YmqGYlc6shK1iY2dr0wtNjYxgHyzaq0OznY235awCr8zSz6
  EGd1QNUKf.74dADTBbTbeotjpW95IolY0WpKYONY8M83Rx2MChx3fL+iG5Mm
  tXpdmvXj8uTvaAL1WjbbarQD4Z6kXBpnm6a69oKV2PY9WY174IbC3CaRQ9iK
  Q4sYGQpwdtZ5wFrc7n569.M83OOR5ydSB1ZcAWCxdbKuavz9LILxfD.wWO.W
  Nq+Zu4Es+AP6s5p9jDWH8ET+c85+XbW0.N1nDCTD7U4DGc6ohnU019fS7kQ0
  o43luuOGjv5agHp0DT.CysOfgLR3xXlXTUKm16RivRsn3z0O6cl3YScAvtrb
  hwekGB7BZuqESUzBJWmCvK7t9HF8Ts6cUAPoFWso3aP8ApWyJ3wqOPo2pJDC
  BQ0NI0Pj8QCQ2r1L5vKaU5lDRYX7yRur1UYYZmJQ9iDHwN9dndB5n5ejflmm
  UsBwLHnDkKXWRuAkb3NeuzqRstiQGP.fCQFdHNzaE.8u58Nz9svFE9SGIE1X
  kv9Iwfl1BdNWjA7xcThsWCS847loyFD8pZq2E2F04lYULzBTDYhrFSDDJdjo
  fisN2NUN26e4xRu51zD5ZseJ4HC63WyIX6jRqsp0jangBnK.Qlo58PCpWevt
  ahzqK7fbKsdX6R64aao8LmWhBPh9jKVAPMzb5a2cV6opdWHneMmqMEmAGsPh
  ieigIjV+4gF1GgbMNXg+NH44YaRYyd..S1ThHzKhFwwGRaWVITqyj9FvPqMT
  d0pDuSqDrOGF.Uogf.juCFi9WAUkYR+rFPanDcPG8SbrtjyG03ZQ8m3AqC5H
  NcUUoXSwVrqXKVcZu.5ZnkwIfIVdXVZTwAuTTUiYuxwjZDK6ZgnRtYV8tJmP
  hEcuXgz2Goxyaiw35UkaWbpqtfzD02oUkkYqi.YQbZqIIWrIljFolsdmMKFR
  wCJ2+DTn.9QlkOld+d9Qy9IJdpLfy05Ik2b8GsG9h8rdm1ZFx1FrmmlA2snw
  qI9Mcdi2nr6q3Gc87nLawurbw1dda+tMyGJ9HaQmlkGwy6davisMgrkM65oz
  eulfYCzG46am8tSDK144xV4cEvVMTRXq9CIX8+ALNWb6sttKNkiZetnbz+lx
  cQnb1Nds2C0tvLNe14hwQtxYbxhqc17qHfamUcZZ3NYSWqjJuiDoizZ+ud2j
  naRK4k3346IIVdR1kKiQjM39adMamvc6n+Xp36Yf3SIGh3uKbquqs1JksTII
  kuJ7RrZSFb2Cn9j5a6DT8cMo0iczU+lsYaU8YNVh5k5uzJLU26ZcfuJE6XLY
  0mcRp9NTCp+L+Ap+in7Xf3b9jFQBLtIY06PbrGhcrU6N00Qlaf9N0+QPo9nS
  P6qsI7aYNLSNOHpsAxis0ggnZLjYqyyFkdSqinVsPaqSDZaYBZ6c93uLCjGm
  iCroJVLzU45iNE.pIUfs3TWb.0FejHp9uANr0GcJPTroFDNOHpkIweLnI1QT
  dHl3P7LhOF3Ahd9rnvLwAMy5JSdNezGlsIsW9mW44r26js+alhxjlkdhN0YE
  YqiH5MTeWo6D4Qm.ieLS7OynmuVGSbmbFUlnWWhiQlhOeN+Yl35bq.tGo9JR
  cj8AVqdz7nSgVB9zNj.FTOU68o5d9KO5TUOGxVMw+jTO8T6wqD0hEiHsOJO5
  TTOMoS.zlqN0SpZjz6GcH05ylVM0jwuidlkmAif374ih5M5QPfccr8Hqifff
  otN8pt3hUcaWu8nosBhwmD0Epw5KmoF.poxy4YHbnjqfPJqcM3Y2vun7nS.i
  f3eETiqcRX2LR.4QmhZrkoCSGwzZrqKHrVR8caari+55d2caPqmq5n.ywe8Q
  WrZL9fpwVXeaogMByE6y1SMdjk+gbavbN7fYvVtt1C2XwHJSzpk+tidUO25H
  UB9onw9mlFQ10fhpZBaDatcMTTEGcJpwzqg92qqiVtM6Cu0IRQ0ndEdfCAqV
  l0qYAUmPrctbxO4XCuPMa1asYzKDks1D52ZCne6Mednz9qW8+.vfqkDA
  -----------end_max5_patcher-----------

*/

]]


examples.Graph = [[

/*
  Graph

  A simple example of communication from the Arduino board to the computer: The
  value of analog input 0 is sent out the serial port. We call this "serial"
  communication because the connection appears to both the Arduino and the
  computer as a serial port, even though it may actually use a USB cable. Bytes
  are sent one after another (serially) from the Arduino to the computer.

  You can use the Arduino Serial Monitor to view the sent data, or it can be
  read by Processing, PD, Max/MSP, or any other program capable of reading data
  from a serial port. The Processing code below graphs the data received so you
  can see the value of the analog input changing over time.

  The circuit:
  - any analog input sensor attached to analog in pin 0

  created 2006
  by David A. Mellis
  modified 9 Apr 2012
  by Tom Igoe and Scott Fitzgerald

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/communication/Graph/
*/

void setup() {
  // initialize the serial communication:
  Serial.begin(9600);
}

void loop() {
  // send the value of analog input 0:
  Serial.println(analogRead(A0));
  // wait a bit for the analog-to-digital converter to stabilize after the last
  // reading:
  delay(2);
}

/* Processing code for this example

  // Graphing sketch

  // This program takes ASCII-encoded strings from the serial port at 9600 baud
  // and graphs them. It expects values in the range 0 to 1023, followed by a
  // newline, or newline and carriage return

  // created 20 Apr 2005
  // updated 24 Nov 2015
  // by Tom Igoe
  // This example code is in the public domain.

  import processing.serial.*;

  Serial myPort;        // The serial port
  int xPos = 1;         // horizontal position of the graph
  float inByte = 0;

  void setup () {
    // set the window size:
    size(400, 300);

    // List all the available serial ports
    // if using Processing 2.1 or later, use Serial.printArray()
    println(Serial.list());

    // I know that the first port in the serial list on my Mac is always my
    // Arduino, so I open Serial.list()[0].
    // Open whatever port is the one you're using.
    myPort = new Serial(this, Serial.list()[0], 9600);

    // don't generate a serialEvent() unless you get a newline character:
    myPort.bufferUntil('\n');

    // set initial background:
    background(0);
  }

  void draw () {
    // draw the line:
    stroke(127, 34, 255);
    line(xPos, height, xPos, height - inByte);

    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
      xPos = 0;
      background(0);
    } else {
      // increment the horizontal position:
      xPos++;
    }
  }

  void serialEvent (Serial myPort) {
    // get the ASCII string:
    String inString = myPort.readStringUntil('\n');

    if (inString != null) {
      // trim off any whitespace:
      inString = trim(inString);
      // convert to an int and map to the screen height:
      inByte = float(inString);
      println(inByte);
      inByte = map(inByte, 0, 1023, 0, height);
    }
  }

*/

/* Max/MSP v5 patch for this example

  ----------begin_max5_patcher----------
  1591.3oc0YszbaaCD9r7uBL5RalQUAO3CvdyS5zVenWZxs5NcfHgjPCIfJIT
  RTxj+6AOHkoTDooroUs0AQPR73a+1cwtK3WtZxzEpOwqlB9YveAlL4KWMYh6
  Q1GLo99ISKXeJMmU451zTUQAWpmNy+NM+SZ2y+sR1l02JuU9t0hJvFlNcMPy
  dOuBv.U5Rgb0LPpRpYBooM3529latArTUVvzZdFPtsXAuDrrTU.f.sBffXxL
  vGE50lIHkUVJXq3fRtdaoDvjYfbgjujaFJSCzq4.tLaN.bi1tJefWpqbO0uz
  1IjIABoluxrJ1guxh2JfPO2B5zRNyBCLDFcqbwNvuv9fHCb8bvevyyEU2JKT
  YhkBSWPAfq2TZ6YhqmuMUo0feUn+rYpY4YtY+cFw3lUJdCMYAapZqzwUHX8S
  crjAd+SIOU6UBAwIygy.Q1+HAA1KH6EveWOFQlitUK92ehfal9kFhUxJ3tWc
  sgpxadigWExbt1o7Ps5dk3yttivyg20W0VcSmg1G90qtx92rAZbH4ez.ruy1
  nhmaDPidE07J+5n2sg6E6oKXxUSmc20o6E3SPRDbrkXnPGUYE.i5nCNB9TxQ
  jG.G0kCTZtH88f07Rt0ZMMWUw8VvbKVAaTk6GyoraPdZff7rQTejBN54lgyv
  HE0Ft7AvIvvgvIwO23jBdUkYOuSvIFSiNcjFhiSsUBwsUCh1AgfNSBAeNDBZ
  DIDqY.f8.YjfjV1HAn9XDTxyNFYatVTkKx3kcK9GraZpI5jv7GOx+Z37Xh82
  LSKHIDmDXaESoXRngIZQDKVkpxUkMCyXCQhcCK1z.G457gi3TzMz4RFD515F
  G3bIQQwcP3SOF0zlkGhiCBQ1kOHHFFlXaEBQIQnCwv9QF1LxPZ.A4jR5cyQs
  vbvHMJsLll01We+rE2LazX6zYmCraRrsPFwKg1ANBZFY.IAihr8Ox.aH0oAL
  hB8nQVw0FSJiZeunOykbT6t3r.NP8.iL+bnwNiXuVMNJH9H9YCm89CFXPBER
  bz422p8.O4dg6kRxdyjDqRwMIHTbT3QFLskxJ8tbmQK4tm0XGeZWF7wKKtYY
  aTAF.XPNFaaQBinQMJ4QLF0aNHF0JtYuHSxoUZfZY6.UU2ejJTb8lQw8Fo5k
  Rv6e2PI+fOM71o2ecY1VgTYdCSxxUqLokuYq9jYJi6lxPgD2NIPePLB0mwbG
  YA9Rgxdiu1k5xiLlSU6JVnx6wzg3sYHwTesB8Z5D7RiGZpXyvDNJY.DQX3.H
  hvmcUN4bP1yCkhpTle2P37jtBsKrLWcMScEmltOPv22ZfAqQAdKr9HzATQwZ
  q18PrUGt6Tst2XMCRUfGuhXs6ccn23YloomMqcTiC5iMGPsHsHRWhWFlaenV
  XcqwgCQiGGJzptyS2ZMODBz6fGza0bzmXBj7+DA94bvpR01MffAlueO7HwcI
  pWCwmzJdvi9ILgflLAFmyXB6O7ML0YbD26lenmcGxjVsZUN+A6pUK7AtTrPg
  M+eRYG0qD9j4I7eEbco8Xh6WcO.or9XDC6UCiewbXHkh6xm5LiPEkzpJDRTu
  mEB44Fgz4NCtJvX.SM1vo2SlTCZGAe7GZu6ahdRyzFOhYZ+mbVVSYptBw.K1
  tboIkatIA7c1cTKD1u.honLYV04VkluHsXe0szv9pQCE9Ro3jaVB1o15pz2X
  zYoBvO5KXCAe0LCYJybE8ZODf4fV8t9qW0zYxq.YJfTosj1bv0xc.SaC0+AV
  9V9L.KKyV3SyTcRtmzi6rO.O16USvts4B5xe9EymDvebK0eMfW6+NIsNlE2m
  eqRyJ0utRq13+RjmqYKN1e.4d61jjdsauXe3.2p6jgi9hsNIv97CoyJ01xzl
  c3ZhUCtSHx3UZgjoEJYqNY+hYs5zZQVFW19L3JDYaTlMLqAAt1G2yXlnFg9a
  53L1FJVcv.cOX0dh7mCVGCLce7GFcQwDdH5Ta3nyAS0pQbHxegr+tGIZORgM
  RnMj5vGl1Fs16drnk7Tf1XOLgv1n0d2iEsCxR.eQsNOZ4FGF7whofgfI3kES
  1kCeOX5L2rifbdu0A9ae2X.V33B1Z+.Bj1FrP5iFrCYCG5EUWSG.hhunHJd.
  HJ5hhnng3h9HPj4lud02.1bxGw.
  -----------end_max5_patcher-----------

*/

]]


examples.toneMultiple = [[

/*
  Multiple tone player

  Plays multiple tones on multiple pins in sequence

  circuit:
  - three 8 ohm speakers on digital pins 6, 7, and 8

  created 8 Mar 2010
  by Tom Igoe
  based on a snippet from Greg Borenstein

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/digital/toneMultiple/
*/

void setup() {
}

void loop() {
  // turn off tone function for pin 8:
  noTone(8);
  // play a note on pin 6 for 200 ms:
  tone(6, 440, 200);
  delay(200);

  // turn off tone function for pin 6:
  noTone(6);
  // play a note on pin 7 for 500 ms:
  tone(7, 494, 500);
  delay(500);

  // turn off tone function for pin 7:
  noTone(7);
  // play a note on pin 8 for 300 ms:
  tone(8, 523, 300);
  delay(300);
}

]]


examples.StringConstructors = [[

/*
  String constructors

  Examples of how to create Strings from other data types

  created 27 Jul 2010
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringConstructors/
*/

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  // send an intro:
  Serial.println("\n\nString Constructors:");
  Serial.println();
}

void loop() {
  // using a constant String:
  String stringOne = "Hello String";
  Serial.println(stringOne);  // prints "Hello String"

  // converting a constant char into a String:
  stringOne = String('a');
  Serial.println(stringOne);  // prints "a"

  // converting a constant string into a String object:
  String stringTwo = String("This is a string");
  Serial.println(stringTwo);  // prints "This is a string"

  // concatenating two strings:
  stringOne = String(stringTwo + " with more");
  // prints "This is a string with more":
  Serial.println(stringOne);

  // using a constant integer:
  stringOne = String(13);
  Serial.println(stringOne);  // prints "13"

  // using an int and a base:
  stringOne = String(analogRead(A0), DEC);
  // prints "453" or whatever the value of analogRead(A0) is
  Serial.println(stringOne);

  // using an int and a base (hexadecimal):
  stringOne = String(45, HEX);
  // prints "2d", which is the hexadecimal version of decimal 45:
  Serial.println(stringOne);

  // using an int and a base (binary)
  stringOne = String(255, BIN);
  // prints "11111111" which is the binary value of 255
  Serial.println(stringOne);

  // using a long and a base:
  stringOne = String(millis(), DEC);
  // prints "123456" or whatever the value of millis() is:
  Serial.println(stringOne);

  // using a float and the right decimal places:
  stringOne = String(5.698, 3);
  Serial.println(stringOne);

  // using a float and less decimal places to use rounding:
  stringOne = String(5.698, 2);
  Serial.println(stringOne);

  // do nothing while true:
  while (true)
    ;
}

]]


examples.StringAppendOperator = [[

/*
  Appending to Strings using the += operator and concat()

  Examples of how to append different data types to Strings

  created 27 Jul 2010
  modified 2 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringAppendOperator/
*/

String stringOne, stringTwo;

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  stringOne = String("Sensor ");
  stringTwo = String("value");
  // send an intro:
  Serial.println("\n\nAppending to a String:");
  Serial.println();
}

void loop() {
  Serial.println(stringOne);  // prints  "Sensor "

  // adding a string to a String:
  stringOne += stringTwo;
  Serial.println(stringOne);  // prints "Sensor value"

  // adding a constant string to a String:
  stringOne += " for input ";
  Serial.println(stringOne);  // prints "Sensor value for input"

  // adding a constant character to a String:
  stringOne += 'A';
  Serial.println(stringOne);  // prints "Sensor value for input A"

  // adding a constant integer to a String:
  stringOne += 0;
  Serial.println(stringOne);  // prints "Sensor value for input A0"

  // adding a constant string to a String:
  stringOne += ": ";
  Serial.println(stringOne);  // prints "Sensor value for input"

  // adding a variable integer to a String:
  stringOne += analogRead(A0);
  Serial.println(stringOne);  // prints "Sensor value for input A0: 456" or whatever analogRead(A0) is

  Serial.println("\n\nchanging the Strings' values");
  stringOne = "A long integer: ";
  stringTwo = "The millis(): ";

  // adding a constant long integer to a String:
  stringOne += 123456789;
  Serial.println(stringOne);  // prints "A long integer: 123456789"

  // using concat() to add a long variable to a String:
  stringTwo.concat(millis());
  Serial.println(stringTwo);  // prints "The millis(): 43534" or whatever the value of the millis() is

  // do nothing while true:
  while (true)
    ;
}

]]


examples.AnalogReadSerial = [[

/*
  AnalogReadSerial

  Reads an analog input on pin 0, prints the result to the Serial Monitor.
  Graphical representation is available using Serial Plotter (Tools > Serial Plotter menu).
  Attach the center pin of a potentiometer to pin A0, and the outside pins to +5V and ground.

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/basics/AnalogReadSerial/
*/

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() {
  // read the input on analog pin 0:
  int sensorValue = analogRead(A0);
  // print out the value you read:
  Serial.println(sensorValue);
  delay(1);  // delay in between reads for stability
}

]]


examples.DigitalInputPullup = [[

/*
  Input Pull-up Serial

  This example demonstrates the use of pinMode(INPUT_PULLUP). It reads a digital
  input on pin 2 and prints the results to the Serial Monitor.

  The circuit:
  - momentary switch attached from pin 2 to ground
  - built-in LED on pin 13

  Unlike pinMode(INPUT), there is no pull-down resistor necessary. An internal
  20K-ohm resistor is pulled to 5V. This configuration causes the input to read
  HIGH when the switch is open, and LOW when it is closed.

  created 14 Mar 2012
  by Scott Fitzgerald

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/digital/InputPullupSerial/
*/

void setup() {
  //start serial connection
  Serial.begin(9600);
  //configure pin 2 as an input and enable the internal pull-up resistor
  pinMode(2, INPUT_PULLUP);
  pinMode(13, OUTPUT);
}

void loop() {
  //read the pushbutton value into a variable
  int sensorVal = digitalRead(2);
  //print out the value of the pushbutton
  Serial.println(sensorVal);

  // Keep in mind the pull-up means the pushbutton's logic is inverted. It goes
  // HIGH when it's open, and LOW when it's pressed. Turn on pin 13 when the
  // button's pressed, and off when it's not:
  if (sensorVal == HIGH) {
    digitalWrite(13, LOW);
  } else {
    digitalWrite(13, HIGH);
  }
}

]]


examples.MultiSerial = [[

/*
  Multiple Serial test

  Receives from the main serial port, sends to the others.
  Receives from serial port 1, sends to the main serial (Serial 0).

  This example works only with boards with more than one serial like Arduino Mega, Due, Zero etc.

  The circuit:
  - any serial device attached to Serial port 1
  - Serial Monitor open on Serial port 0

  created 30 Dec 2008
  modified 20 May 2012
  by Tom Igoe & Jed Roach
  modified 27 Nov 2015
  by Arturo Guadalupi

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/communication/MultiSerialMega/
*/


void setup() {
  // initialize both serial ports:
  Serial.begin(9600);
  Serial1.begin(9600);
}

void loop() {
  // read from port 1, send to port 0:
  if (Serial1.available()) {
    int inByte = Serial1.read();
    Serial.write(inByte);
  }

  // read from port 0, send to port 1:
  if (Serial.available()) {
    int inByte = Serial.read();
    Serial1.write(inByte);
  }
}

]]


examples.StringSubstring = [[

/*
  String substring()

  Examples of how to use substring in a String

  created 27 Jul 2010,
  modified 2 Apr 2012
  by Zach Eveland

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringSubstring/
*/

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  // send an intro:
  Serial.println("\n\nString  substring():");
  Serial.println();
}

void loop() {
  // Set up a String:
  String stringOne = "Content-Type: text/html";
  Serial.println(stringOne);

  // substring(index) looks for the substring from the index position to the end:
  if (stringOne.substring(19) == "html") {
    Serial.println("It's an html file");
  }
  // you can also look for a substring in the middle of a string:
  if (stringOne.substring(14, 18) == "text") {
    Serial.println("It's a text-based file");
  }

  // do nothing while true:
  while (true)
    ;
}

]]


examples.StringCharacters = [[

/*
  String charAt() and setCharAt()

  Examples of how to get and set characters of a String

  created 27 Jul 2010
  modified 2 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringCharacters/
*/

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  Serial.println("\n\nString charAt() and setCharAt():");
}

void loop() {
  // make a String to report a sensor reading:
  String reportString = "SensorReading: 456";
  Serial.println(reportString);

  // the reading's most significant digit is at position 15 in the reportString:
  char mostSignificantDigit = reportString.charAt(15);

  String message = "Most significant digit of the sensor reading is: ";
  Serial.println(message + mostSignificantDigit);

  // add blank space:
  Serial.println();

  // you can also set the character of a String. Change the : to a = character
  reportString.setCharAt(13, '=');
  Serial.println(reportString);

  // do nothing while true:
  while (true)
    ;
}

]]


examples.KeyboardReprogram = [[

/*
  Arduino Programs Blink

  This sketch demonstrates the Keyboard library.

  For Leonardo and Due boards only.

  When you connect pin 2 to ground, it creates a new window with a key
  combination (CTRL-N), then types in the Blink sketch, then auto-formats the
  text using another key combination (CTRL-T), then uploads the sketch to the
  currently selected Arduino using a final key combination (CTRL-U).

  Circuit:
  - Arduino Leonardo, Micro, Due, LilyPad USB, or Yún
  - wire to connect D2 to ground

  created 5 Mar 2012
  modified 29 Mar 2012
  by Tom Igoe
  modified 3 May 2014
  by Scott Fitzgerald

  This example is in the public domain.

  https://docs.arduino.cc/built-in-examples/usb/KeyboardReprogram/
*/

#include "Keyboard.h"

// use this option for OSX.
// Comment it out if using Windows or Linux:
char ctrlKey = KEY_LEFT_GUI;
// use this option for Windows and Linux.
// leave commented out if using OSX:
//  char ctrlKey = KEY_LEFT_CTRL;


void setup() {
  // make pin 2 an input and turn on the pull-up resistor so it goes high unless
  // connected to ground:
  pinMode(2, INPUT_PULLUP);
  // initialize control over the keyboard:
  Keyboard.begin();
}

void loop() {
  while (digitalRead(2) == HIGH) {
    // do nothing until pin 2 goes low
    delay(500);
  }
  delay(1000);
  // new document:
  Keyboard.press(ctrlKey);
  Keyboard.press('n');
  delay(100);
  Keyboard.releaseAll();
  // wait for new window to open:
  delay(1000);

  // versions of the Arduino IDE after 1.5 pre-populate new sketches with
  // setup() and loop() functions let's clear the window before typing anything new
  // select all
  Keyboard.press(ctrlKey);
  Keyboard.press('a');
  delay(500);
  Keyboard.releaseAll();
  // delete the selected text
  Keyboard.write(KEY_BACKSPACE);
  delay(500);

  // Type out "blink":
  Keyboard.println("void setup() {");
  Keyboard.println("pinMode(13, OUTPUT);");
  Keyboard.println("}");
  Keyboard.println();
  Keyboard.println("void loop() {");
  Keyboard.println("digitalWrite(13, HIGH);");
  Keyboard.print("delay(3000);");
  // 3000 ms is too long. Delete it:
  for (int keystrokes = 0; keystrokes < 6; keystrokes++) {
    delay(500);
    Keyboard.write(KEY_BACKSPACE);
  }
  // make it 1000 instead:
  Keyboard.println("1000);");
  Keyboard.println("digitalWrite(13, LOW);");
  Keyboard.println("delay(1000);");
  Keyboard.println("}");
  // tidy up:
  Keyboard.press(ctrlKey);
  Keyboard.press('t');
  delay(100);
  Keyboard.releaseAll();
  delay(3000);
  // upload code:
  Keyboard.press(ctrlKey);
  Keyboard.press('u');
  delay(100);
  Keyboard.releaseAll();

  // wait for the sweet oblivion of reprogramming:
  while (true)
    ;
}

]]


examples.Smoothing = [[

/*
  Smoothing

  Reads repeatedly from an analog input, calculating a running average and
  printing it to the computer. Keeps ten readings in an array and continually
  averages them.

  The circuit:
  - analog sensor (potentiometer will do) attached to analog input 0

  created 22 Apr 2007
  by David A. Mellis  <dam@mellis.org>
  modified 9 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/analog/Smoothing/
*/

// Define the number of samples to keep track of. The higher the number, the
// more the readings will be smoothed, but the slower the output will respond to
// the input. Using a constant rather than a normal variable lets us use this
// value to determine the size of the readings array.
const int numReadings = 10;

int readings[numReadings];  // the readings from the analog input
int readIndex = 0;          // the index of the current reading
int total = 0;              // the running total
int average = 0;            // the average

int inputPin = A0;

void setup() {
  // initialize serial communication with computer:
  Serial.begin(9600);
  // initialize all the readings to 0:
  for (int thisReading = 0; thisReading < numReadings; thisReading++) {
    readings[thisReading] = 0;
  }
}

void loop() {
  // subtract the last reading:
  total = total - readings[readIndex];
  // read from the sensor:
  readings[readIndex] = analogRead(inputPin);
  // add the reading to the total:
  total = total + readings[readIndex];
  // advance to the next position in the array:
  readIndex = readIndex + 1;

  // if we're at the end of the array...
  if (readIndex >= numReadings) {
    // ...wrap around to the beginning:
    readIndex = 0;
  }

  // calculate the average:
  average = total / numReadings;
  // send it to the computer as ASCII digits
  Serial.println(average);
  delay(1);  // delay in between reads for stability
}

]]


examples.JoystickMouseControl = [[

/*
  JoystickMouseControl

  Controls the mouse from a joystick on an Arduino Leonardo, Micro or Due.
  Uses a pushbutton to turn on and off mouse control, and a second pushbutton
  to click the left mouse button.

  Hardware:
  - 2-axis joystick connected to pins A0 and A1
  - pushbuttons connected to pin D2 and D3

  The mouse movement is always relative. This sketch reads two analog inputs
  that range from 0 to 1023 (or less on either end) and translates them into
  ranges of -6 to 6.
  The sketch assumes that the joystick resting values are around the middle of
  the range, but that they vary within a threshold.

  WARNING: When you use the Mouse.move() command, the Arduino takes over your
  mouse! Make sure you have control before you use the command. This sketch
  includes a pushbutton to toggle the mouse control state, so you can turn on
  and off mouse control.

  created 15 Sep 2011
  updated 28 Mar 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/usb/JoystickMouseControl/
*/

#include "Mouse.h"

// set pin numbers for switch, joystick axes, and LED:
const int switchPin = 2;    // switch to turn on and off mouse control
const int mouseButton = 3;  // input pin for the mouse pushButton
const int xAxis = A0;       // joystick X axis
const int yAxis = A1;       // joystick Y axis
const int ledPin = 5;       // Mouse control LED

// parameters for reading the joystick:
int range = 12;             // output range of X or Y movement
int responseDelay = 5;      // response delay of the mouse, in ms
int threshold = range / 4;  // resting threshold
int center = range / 2;     // resting position value

bool mouseIsActive = false;  // whether or not to control the mouse
int lastSwitchState = LOW;   // previous switch state

void setup() {
  pinMode(switchPin, INPUT);  // the switch pin
  pinMode(ledPin, OUTPUT);    // the LED pin
  // take control of the mouse:
  Mouse.begin();
}

void loop() {
  // read the switch:
  int switchState = digitalRead(switchPin);
  // if it's changed and it's high, toggle the mouse state:
  if (switchState != lastSwitchState) {
    if (switchState == HIGH) {
      mouseIsActive = !mouseIsActive;
      // turn on LED to indicate mouse state:
      digitalWrite(ledPin, mouseIsActive);
    }
  }
  // save switch state for next comparison:
  lastSwitchState = switchState;

  // read and scale the two axes:
  int xReading = readAxis(A0);
  int yReading = readAxis(A1);

  // if the mouse control state is active, move the mouse:
  if (mouseIsActive) {
    Mouse.move(xReading, yReading, 0);
  }

  // read the mouse button and click or not click:
  // if the mouse button is pressed:
  if (digitalRead(mouseButton) == HIGH) {
    // if the mouse is not pressed, press it:
    if (!Mouse.isPressed(MOUSE_LEFT)) {
      Mouse.press(MOUSE_LEFT);
    }
  }
  // else the mouse button is not pressed:
  else {
    // if the mouse is pressed, release it:
    if (Mouse.isPressed(MOUSE_LEFT)) {
      Mouse.release(MOUSE_LEFT);
    }
  }

  delay(responseDelay);
}

/*
  reads an axis (0 or 1 for x or y) and scales the analog input range to a range
  from 0 to <range>
*/

int readAxis(int thisAxis) {
  // read the analog input:
  int reading = analogRead(thisAxis);

  // map the reading from the analog input range to the output range:
  reading = map(reading, 0, 1023, 0, range);

  // if the output reading is outside from the rest position threshold, use it:
  int distance = reading - center;

  if (abs(distance) < threshold) {
    distance = 0;
  }

  // return the distance for this axis:
  return distance;
}

]]


examples.p10_Zoetrope = [[

/*
  Arduino Starter Kit example
  Project 10 - Zoetrope

  This sketch is written to accompany Project 10 in the Arduino Starter Kit

  Parts required:
  - two 10 kilohm resistors
  - two momentary pushbuttons
  - one 10 kilohm potentiometer
  - motor
  - 9V battery
  - H-Bridge

  created 13 Sep 2012
  by Scott Fitzgerald
  Thanks to Federico Vanzati for improvements

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

const int controlPin1 = 2;                // connected to pin 7 on the H-bridge
const int controlPin2 = 3;                // connected to pin 2 on the H-bridge
const int enablePin = 9;                  // connected to pin 1 on the H-bridge
const int directionSwitchPin = 4;         // connected to the switch for direction
const int onOffSwitchStateSwitchPin = 5;  // connected to the switch for turning the motor on and off
const int potPin = A0;                    // connected to the potentiometer's output

// create some variables to hold values from your inputs
int onOffSwitchState = 0;              // current state of the on/off switch
int previousOnOffSwitchState = 0;      // previous position of the on/off switch
int directionSwitchState = 0;          // current state of the direction switch
int previousDirectionSwitchState = 0;  // previous state of the direction switch

int motorEnabled = 0;    // Turns the motor on/off
int motorSpeed = 0;      // speed of the motor
int motorDirection = 1;  // current direction of the motor

void setup() {
  // initialize the inputs and outputs
  pinMode(directionSwitchPin, INPUT);
  pinMode(onOffSwitchStateSwitchPin, INPUT);
  pinMode(controlPin1, OUTPUT);
  pinMode(controlPin2, OUTPUT);
  pinMode(enablePin, OUTPUT);

  // pull the enable pin LOW to start
  digitalWrite(enablePin, LOW);
}

void loop() {
  // read the value of the on/off switch
  onOffSwitchState = digitalRead(onOffSwitchStateSwitchPin);
  delay(1);

  // read the value of the direction switch
  directionSwitchState = digitalRead(directionSwitchPin);

  // read the value of the pot and divide by 4 to get a value that can be
  // used for PWM
  motorSpeed = analogRead(potPin) / 4;

  // if the on/off button changed state since the last loop()
  if (onOffSwitchState != previousOnOffSwitchState) {
    // change the value of motorEnabled if pressed
    if (onOffSwitchState == HIGH) {
      motorEnabled = !motorEnabled;
    }
  }

  // if the direction button changed state since the last loop()
  if (directionSwitchState != previousDirectionSwitchState) {
    // change the value of motorDirection if pressed
    if (directionSwitchState == HIGH) {
      motorDirection = !motorDirection;
    }
  }

  // change the direction the motor spins by talking to the control pins
  // on the H-Bridge
  if (motorDirection == 1) {
    digitalWrite(controlPin1, HIGH);
    digitalWrite(controlPin2, LOW);
  } else {
    digitalWrite(controlPin1, LOW);
    digitalWrite(controlPin2, HIGH);
  }

  // if the motor is supposed to be on
  if (motorEnabled == 1) {
    // PWM the enable pin to vary the speed
    analogWrite(enablePin, motorSpeed);
  } else {  // if the motor is not supposed to be on
    //turn the motor off
    analogWrite(enablePin, 0);
  }
  // save the current on/off switch state as the previous
  previousDirectionSwitchState = directionSwitchState;
  // save the current switch state as the previous
  previousOnOffSwitchState = onOffSwitchState;
}

]]


examples.Debounce = [[

/*
  Debounce

  Each time the input pin goes from LOW to HIGH (e.g. because of a push-button
  press), the output pin is toggled from LOW to HIGH or HIGH to LOW. There's a
  minimum delay between toggles to debounce the circuit (i.e. to ignore noise).

  The circuit:
  - LED attached from pin 13 to ground through 220 ohm resistor
  - pushbutton attached from pin 2 to +5V
  - 10 kilohm resistor attached from pin 2 to ground

  - Note: On most Arduino boards, there is already an LED on the board connected
    to pin 13, so you don't need any extra components for this example.

  created 21 Nov 2006
  by David A. Mellis
  modified 30 Aug 2011
  by Limor Fried
  modified 28 Dec 2012
  by Mike Walters
  modified 30 Aug 2016
  by Arturo Guadalupi

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/digital/Debounce/
*/

// constants won't change. They're used here to set pin numbers:
const int buttonPin = 2;  // the number of the pushbutton pin
const int ledPin = 13;    // the number of the LED pin

// Variables will change:
int ledState = HIGH;        // the current state of the output pin
int buttonState;            // the current reading from the input pin
int lastButtonState = LOW;  // the previous reading from the input pin

// the following variables are unsigned longs because the time, measured in
// milliseconds, will quickly become a bigger number than can be stored in an int.
unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 50;    // the debounce time; increase if the output flickers

void setup() {
  pinMode(buttonPin, INPUT);
  pinMode(ledPin, OUTPUT);

  // set initial LED state
  digitalWrite(ledPin, ledState);
}

void loop() {
  // read the state of the switch into a local variable:
  int reading = digitalRead(buttonPin);

  // check to see if you just pressed the button
  // (i.e. the input went from LOW to HIGH), and you've waited long enough
  // since the last press to ignore any noise:

  // If the switch changed, due to noise or pressing:
  if (reading != lastButtonState) {
    // reset the debouncing timer
    lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    // whatever the reading is at, it's been there for longer than the debounce
    // delay, so take it as the actual current state:

    // if the button state has changed:
    if (reading != buttonState) {
      buttonState = reading;

      // only toggle the LED if the new button state is HIGH
      if (buttonState == HIGH) {
        ledState = !ledState;
      }
    }
  }

  // set the LED:
  digitalWrite(ledPin, ledState);

  // save the reading. Next time through the loop, it'll be the lastButtonState:
  lastButtonState = reading;
}

]]


examples.SerialEvent = [[

/*
  Serial Event example

  When new serial data arrives, this sketch adds it to a String.
  When a newline is received, the loop prints the string and clears it.

  A good test for this is to try it with a GPS receiver that sends out
  NMEA 0183 sentences.

  NOTE: The serialEvent() feature is not available on the Leonardo, Micro, or
  other ATmega32U4 based boards.

  created 9 May 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/communication/SerialEvent/
*/

String inputString = "";      // a String to hold incoming data
bool stringComplete = false;  // whether the string is complete

void setup() {
  // initialize serial:
  Serial.begin(9600);
  // reserve 200 bytes for the inputString:
  inputString.reserve(200);
}

void loop() {
  // print the string when a newline arrives:
  if (stringComplete) {
    Serial.println(inputString);
    // clear the string:
    inputString = "";
    stringComplete = false;
  }
}

/*
  SerialEvent occurs whenever a new data comes in the hardware serial RX. This
  routine is run between each time loop() runs, so using delay inside loop can
  delay response. Multiple bytes of data may be available.
*/
void serialEvent() {
  while (Serial.available()) {
    // get the new byte:
    char inChar = (char)Serial.read();
    // add it to the inputString:
    inputString += inChar;
    // if the incoming character is a newline, set a flag so the main loop can
    // do something about it:
    if (inChar == '\n') {
      stringComplete = true;
    }
  }
}

]]


examples.BareMinimum = [[

void setup() {
  // put your setup code here, to run once:
}

void loop() {
  // put your main code here, to run repeatedly:
}

]]


examples.BlinkWithoutDelay = [[

/*
  Blink without Delay

  Turns on and off a light emitting diode (LED) connected to a digital pin,
  without using the delay() function. This means that other code can run at the
  same time without being interrupted by the LED code.

  The circuit:
  - Use the onboard LED.
  - Note: Most Arduinos have an on-board LED you can control. On the UNO, MEGA
    and ZERO it is attached to digital pin 13, on MKR1000 on pin 6. LED_BUILTIN
    is set to the correct LED pin independent of which board is used.
    If you want to know what pin the on-board LED is connected to on your
    Arduino model, check the Technical Specs of your board at:
    https://docs.arduino.cc/hardware/

  created 2005
  by David A. Mellis
  modified 8 Feb 2010
  by Paul Stoffregen
  modified 11 Nov 2013
  by Scott Fitzgerald
  modified 9 Jan 2017
  by Arturo Guadalupi

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/digital/BlinkWithoutDelay/
*/

// constants won't change. Used here to set a pin number:
const int ledPin = LED_BUILTIN;  // the number of the LED pin

// Variables will change:
int ledState = LOW;  // ledState used to set the LED

// Generally, you should use "unsigned long" for variables that hold time
// The value will quickly become too large for an int to store
unsigned long previousMillis = 0;  // will store last time LED was updated

// constants won't change:
const long interval = 1000;  // interval at which to blink (milliseconds)

void setup() {
  // set the digital pin as output:
  pinMode(ledPin, OUTPUT);
}

void loop() {
  // here is where you'd put code that needs to be running all the time.

  // check to see if it's time to blink the LED; that is, if the difference
  // between the current time and last time you blinked the LED is bigger than
  // the interval at which you want to blink the LED.
  unsigned long currentMillis = millis();

  if (currentMillis - previousMillis >= interval) {
    // save the last time you blinked the LED
    previousMillis = currentMillis;

    // if the LED is off turn it on and vice-versa:
    if (ledState == LOW) {
      ledState = HIGH;
    } else {
      ledState = LOW;
    }

    // set the LED with the ledState of the variable:
    digitalWrite(ledPin, ledState);
  }
}

]]


examples.StringLengthTrim = [[

/*
  String length() and trim()

  Examples of how to use length() and trim() in a String

  created 27 Jul 2010
  modified 2 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringLengthTrim/
*/

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  // send an intro:
  Serial.println("\n\nString length() and trim():");
  Serial.println();
}

void loop() {
  // here's a String with empty spaces at the end (called white space):
  String stringOne = "Hello!       ";
  Serial.print(stringOne);
  Serial.print("<--- end of string. Length: ");
  Serial.println(stringOne.length());

  // trim the white space off the string:
  stringOne.trim();
  Serial.print(stringOne);
  Serial.print("<--- end of trimmed string. Length: ");
  Serial.println(stringOne.length());

  // do nothing while true:
  while (true)
    ;
}

]]


examples.p07_Keyboard = [[

/*
  Arduino Starter Kit example
  Project 7 - Keyboard

  This sketch is written to accompany Project 7 in the Arduino Starter Kit

  Parts required:
  - two 10 kilohm resistors
  - 1 megohm resistor
  - 220 ohm resistor
  - four pushbuttons
  - piezo

  created 13 Sep 2012
  by Scott Fitzgerald

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

// create an array of notes
// the numbers below correspond to the frequencies of middle C, D, E, and F
int notes[] = { 262, 294, 330, 349 };

void setup() {
  //start serial communication
  Serial.begin(9600);
}

void loop() {
  // create a local variable to hold the input on pin A0
  int keyVal = analogRead(A0);
  // send the value from A0 to the Serial Monitor
  Serial.println(keyVal);

  // play the note corresponding to each value on A0
  if (keyVal == 1023) {
    // play the first frequency in the array on pin 8
    tone(8, notes[0]);
  } else if (keyVal >= 990 && keyVal <= 1010) {
    // play the second frequency in the array on pin 8
    tone(8, notes[1]);
  } else if (keyVal >= 505 && keyVal <= 515) {
    // play the third frequency in the array on pin 8
    tone(8, notes[2]);
  } else if (keyVal >= 5 && keyVal <= 10) {
    // play the fourth frequency in the array on pin 8
    tone(8, notes[3]);
  } else {
    // if the value is out of range, play no tone
    noTone(8);
  }
}

]]


examples.StateChangeDetection = [[

/*
  State change detection (edge detection)

  Often, you don't need to know the state of a digital input all the time, but
  you just need to know when the input changes from one state to another.
  For example, you want to know when a button goes from OFF to ON. This is called
  state change detection, or edge detection.

  This example shows how to detect when a button or button changes from off to on
  and on to off.

  The circuit:
  - pushbutton attached to pin 2 from +5V
  - 10 kilohm resistor attached to pin 2 from ground
  - LED attached from pin 13 to ground through 220 ohm resistor (or use the
    built-in LED on most Arduino boards)

  created  27 Sep 2005
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/digital/StateChangeDetection/
*/

// this constant won't change:
const int buttonPin = 2;  // the pin that the pushbutton is attached to
const int ledPin = 13;    // the pin that the LED is attached to

// Variables will change:
int buttonPushCounter = 0;  // counter for the number of button presses
int buttonState = 0;        // current state of the button
int lastButtonState = 0;    // previous state of the button

void setup() {
  // initialize the button pin as a input:
  pinMode(buttonPin, INPUT);
  // initialize the LED as an output:
  pinMode(ledPin, OUTPUT);
  // initialize serial communication:
  Serial.begin(9600);
}


void loop() {
  // read the pushbutton input pin:
  buttonState = digitalRead(buttonPin);

  // compare the buttonState to its previous state
  if (buttonState != lastButtonState) {
    // if the state has changed, increment the counter
    if (buttonState == HIGH) {
      // if the current state is HIGH then the button went from off to on:
      buttonPushCounter++;
      Serial.println("on");
      Serial.print("number of button pushes: ");
      Serial.println(buttonPushCounter);
    } else {
      // if the current state is LOW then the button went from on to off:
      Serial.println("off");
    }
    // Delay a little bit to avoid bouncing
    delay(50);
  }
  // save the current state as the last state, for next time through the loop
  lastButtonState = buttonState;


  // turns on the LED every four button pushes by checking the modulo of the
  // button push counter. the modulo function gives you the remainder of the
  // division of two numbers:
  if (buttonPushCounter % 4 == 0) {
    digitalWrite(ledPin, HIGH);
  } else {
    digitalWrite(ledPin, LOW);
  }
}

]]


examples.StringCaseChanges = [[

/*
  String Case changes

  Examples of how to change the case of a String

  created 27 Jul 2010
  modified 2 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringCaseChanges/
*/

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  // send an intro:
  Serial.println("\n\nString case changes:");
  Serial.println();
}

void loop() {
  // toUpperCase() changes all letters to upper case:
  String stringOne = "<html><head><body>";
  Serial.println(stringOne);
  stringOne.toUpperCase();
  Serial.println(stringOne);

  // toLowerCase() changes all letters to lower case:
  String stringTwo = "</BODY></HTML>";
  Serial.println(stringTwo);
  stringTwo.toLowerCase();
  Serial.println(stringTwo);


  // do nothing while true:
  while (true)
    ;
}

]]


examples.StringComparisonOperators = [[

/*
  Comparing Strings

  Examples of how to compare Strings using the comparison operators

  created 27 Jul 2010
  modified 2 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringComparisonOperators/
*/

String stringOne, stringTwo;

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }


  stringOne = String("this");
  stringTwo = String("that");
  // send an intro:
  Serial.println("\n\nComparing Strings:");
  Serial.println();
}

void loop() {
  // two Strings equal:
  if (stringOne == "this") {
    Serial.println("StringOne == \"this\"");
  }
  // two Strings not equal:
  if (stringOne != stringTwo) {
    Serial.println(stringOne + " =! " + stringTwo);
  }

  // two Strings not equal (case sensitivity matters):
  stringOne = "This";
  stringTwo = "this";
  if (stringOne != stringTwo) {
    Serial.println(stringOne + " =! " + stringTwo);
  }
  // you can also use equals() to see if two Strings are the same:
  if (stringOne.equals(stringTwo)) {
    Serial.println(stringOne + " equals " + stringTwo);
  } else {
    Serial.println(stringOne + " does not equal " + stringTwo);
  }

  // or perhaps you want to ignore case:
  if (stringOne.equalsIgnoreCase(stringTwo)) {
    Serial.println(stringOne + " equals (ignoring case) " + stringTwo);
  } else {
    Serial.println(stringOne + " does not equal (ignoring case) " + stringTwo);
  }

  // a numeric String compared to the number it represents:
  stringOne = "1";
  int numberOne = 1;
  if (stringOne.toInt() == numberOne) {
    Serial.println(stringOne + " = " + numberOne);
  }



  // two numeric Strings compared:
  stringOne = "2";
  stringTwo = "1";
  if (stringOne >= stringTwo) {
    Serial.println(stringOne + " >= " + stringTwo);
  }

  // comparison operators can be used to compare Strings for alphabetic sorting too:
  stringOne = String("Brown");
  if (stringOne < "Charles") {
    Serial.println(stringOne + " < Charles");
  }

  if (stringOne > "Adams") {
    Serial.println(stringOne + " > Adams");
  }

  if (stringOne <= "Browne") {
    Serial.println(stringOne + " <= Browne");
  }


  if (stringOne >= "Brow") {
    Serial.println(stringOne + " >= Brow");
  }

  // the compareTo() operator also allows you to compare Strings
  // it evaluates on the first character that's different.
  // if the first character of the String you're comparing to comes first in
  // alphanumeric order, then compareTo() is greater than 0:
  stringOne = "Cucumber";
  stringTwo = "Cucuracha";
  if (stringOne.compareTo(stringTwo) < 0) {
    Serial.println(stringOne + " comes before " + stringTwo);
  } else {
    Serial.println(stringOne + " comes after " + stringTwo);
  }

  delay(10000);  // because the next part is a loop:

  // compareTo() is handy when you've got Strings with numbers in them too:

  while (true) {
    stringOne = "Sensor: ";
    stringTwo = "Sensor: ";

    stringOne += analogRead(A0);
    stringTwo += analogRead(A5);

    if (stringOne.compareTo(stringTwo) < 0) {
      Serial.println(stringOne + " comes before " + stringTwo);
    } else {
      Serial.println(stringOne + " comes after " + stringTwo);
    }
  }
}

]]


examples.ASCIITable = [[

/*
  ASCII table

  Prints out byte values in all possible formats:
  - as raw binary values
  - as ASCII-encoded decimal, hex, octal, and binary values

  For more on ASCII, see http://www.asciitable.com and http://en.wikipedia.org/wiki/ASCII

  The circuit: No external hardware needed.

  created 2006
  by Nicholas Zambetti <http://www.zambetti.com>
  modified 9 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/communication/ASCIITable/
*/

void setup() {
  //Initialize serial and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  // prints title with ending line break
  Serial.println("ASCII Table ~ Character Map");
}

// first visible ASCIIcharacter '!' is number 33:
int thisByte = 33;
// you can also write ASCII characters in single quotes.
// for example, '!' is the same as 33, so you could also use this:
// int thisByte = '!';

void loop() {
  // prints value unaltered, i.e. the raw binary version of the byte.
  // The Serial Monitor interprets all bytes as ASCII, so 33, the first number,
  // will show up as '!'
  Serial.write(thisByte);

  Serial.print(", dec: ");
  // prints value as string as an ASCII-encoded decimal (base 10).
  // Decimal is the default format for Serial.print() and Serial.println(),
  // so no modifier is needed:
  Serial.print(thisByte);
  // But you can declare the modifier for decimal if you want to.
  // this also works if you uncomment it:

  // Serial.print(thisByte, DEC);


  Serial.print(", hex: ");
  // prints value as string in hexadecimal (base 16):
  Serial.print(thisByte, HEX);

  Serial.print(", oct: ");
  // prints value as string in octal (base 8);
  Serial.print(thisByte, OCT);

  Serial.print(", bin: ");
  // prints value as string in binary (base 2) also prints ending line break:
  Serial.println(thisByte, BIN);

  // if printed last visible character '~' or 126, stop:
  if (thisByte == 126) {  // you could also use if (thisByte == '~') {
    // This loop loops forever and does nothing
    while (true) {
      continue;
    }
  }
  // go on to the next character
  thisByte++;
}

]]


examples.KeyboardLogout = [[

/*
  Keyboard logout

  This sketch demonstrates the Keyboard library.

  When you connect pin 2 to ground, it performs a logout.
  It uses keyboard combinations to do this, as follows:

  On Windows, CTRL-ALT-DEL followed by ALT-l
  On Ubuntu, CTRL-ALT-DEL, and ENTER
  On OSX, CMD-SHIFT-q

  To wake: Spacebar.

  Circuit:
  - Arduino Leonardo or Micro
  - wire to connect D2 to ground

  created 6 Mar 2012
  modified 27 Mar 2012
  by Tom Igoe

  This example is in the public domain.

  https://docs.arduino.cc/built-in-examples/usb/KeyboardLogout/
*/

#define OSX 0
#define WINDOWS 1
#define UBUNTU 2

#include "Keyboard.h"

// change this to match your platform:
int platform = OSX;

void setup() {
  // make pin 2 an input and turn on the pull-up resistor so it goes high unless
  // connected to ground:
  pinMode(2, INPUT_PULLUP);
  Keyboard.begin();
}

void loop() {
  while (digitalRead(2) == HIGH) {
    // do nothing until pin 2 goes low
    delay(500);
  }
  delay(1000);

  switch (platform) {
    case OSX:
      Keyboard.press(KEY_LEFT_GUI);
      // Shift-Q logs out:
      Keyboard.press(KEY_LEFT_SHIFT);
      Keyboard.press('Q');
      delay(100);
      Keyboard.releaseAll();
      // enter:
      Keyboard.write(KEY_RETURN);
      break;
    case WINDOWS:
      // CTRL-ALT-DEL:
      Keyboard.press(KEY_LEFT_CTRL);
      Keyboard.press(KEY_LEFT_ALT);
      Keyboard.press(KEY_DELETE);
      delay(100);
      Keyboard.releaseAll();
      // ALT-l:
      delay(2000);
      Keyboard.press(KEY_LEFT_ALT);
      Keyboard.press('l');
      Keyboard.releaseAll();
      break;
    case UBUNTU:
      // CTRL-ALT-DEL:
      Keyboard.press(KEY_LEFT_CTRL);
      Keyboard.press(KEY_LEFT_ALT);
      Keyboard.press(KEY_DELETE);
      delay(1000);
      Keyboard.releaseAll();
      // Enter to confirm logout:
      Keyboard.write(KEY_RETURN);
      break;
  }

  // do nothing:
  while (true)
    ;
}

]]


examples.PhysicalPixel = [[

/*
  Physical Pixel

  An example of using the Arduino board to receive data from the computer. In
  this case, the Arduino boards turns on an LED when it receives the character
  'H', and turns off the LED when it receives the character 'L'.

  The data can be sent from the Arduino Serial Monitor, or another program like
  Processing (see code below), Flash (via a serial-net proxy), PD, or Max/MSP.

  The circuit:
  - LED connected from digital pin 13 to ground through 220 ohm resistor

  created 2006
  by David A. Mellis
  modified 30 Aug 2011
  by Tom Igoe and Scott Fitzgerald

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/communication/PhysicalPixel/
*/

const int ledPin = 13;  // the pin that the LED is attached to
int incomingByte;       // a variable to read incoming serial data into

void setup() {
  // initialize serial communication:
  Serial.begin(9600);
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);
}

void loop() {
  // see if there's incoming serial data:
  if (Serial.available() > 0) {
    // read the oldest byte in the serial buffer:
    incomingByte = Serial.read();
    // if it's a capital H (ASCII 72), turn on the LED:
    if (incomingByte == 'H') {
      digitalWrite(ledPin, HIGH);
    }
    // if it's an L (ASCII 76) turn off the LED:
    if (incomingByte == 'L') {
      digitalWrite(ledPin, LOW);
    }
  }
}

/* Processing code for this example

  // Mouse over serial

  // Demonstrates how to send data to the Arduino I/O board, in order to turn ON
  // a light if the mouse is over a square and turn it off if the mouse is not.

  // created 2003-4
  // based on examples by Casey Reas and Hernando Barragan
  // modified 30 Aug 2011
  // by Tom Igoe
  // This example code is in the public domain.

  import processing.serial.*;

  float boxX;
  float boxY;
  int boxSize = 20;
  boolean mouseOverBox = false;

  Serial port;

  void setup() {
    size(200, 200);
    boxX = width / 2.0;
    boxY = height / 2.0;
    rectMode(RADIUS);

    // List all the available serial ports in the output pane.
    // You will need to choose the port that the Arduino board is connected to
    // from this list. The first port in the list is port #0 and the third port
    // in the list is port #2.
    // if using Processing 2.1 or later, use Serial.printArray()
    println(Serial.list());

    // Open the port that the Arduino board is connected to (in this case #0)
    // Make sure to open the port at the same speed Arduino is using (9600bps)
    port = new Serial(this, Serial.list()[0], 9600);
  }

  void draw() {
    background(0);

    // Test if the cursor is over the box
    if (mouseX > boxX - boxSize && mouseX < boxX + boxSize &&
        mouseY > boxY - boxSize && mouseY < boxY + boxSize) {
      mouseOverBox = true;
      // draw a line around the box and change its color:
      stroke(255);
      fill(153);
      // send an 'H' to indicate mouse is over square:
      port.write('H');
    }
    else {
      // return the box to its inactive state:
      stroke(153);
      fill(153);
      // send an 'L' to turn the LED off:
      port.write('L');
      mouseOverBox = false;
    }

    // Draw the box
    rect(boxX, boxY, boxSize, boxSize);
  }

*/

/* Max/MSP version 5 patch to run with this example:

  ----------begin_max5_patcher----------
  1672.3oc2ZszaaiCD9ryuBBebQVCQRYao8xhf1cQCPVfBzh8RRQ.sDsM2HSZ
  HQmlzh9eu7gjsjsEk7y0oWjiHoHm4aluYHGlueUmtiDuPy5B9Cv8fNc99Uc5
  XZR2Pm726zcF4knDRlYXciDylQ4xtWa6SReQZZ+iSeMiEQR.ej8BM4A9C7OO
  kkAlSjQSAYTdbFfvA27o2c6sfO.Doqd6NfXgDHmRUCKkolg4hT06BfbQJGH3
  5Qd2e8d.QJIQSow5tzebZ7BFW.FIHow8.2JAQpVIIYByxo9KIMkSjL9D0BRT
  sbGHZJIkDoZOSMuQT.8YZ5qpgGI3locF4IpQRzq2nDF+odZMIJkRjpEF44M3
  A9nWAum7LKFbSOv+PSRXYOvmIhYiYpg.8A2LOUOxPyH+TjPJA+MS9sIzTRRr
  QP9rXF31IBZAHpVHkHrfaPRHLuUCzoj9GSoQRqIB52y6Z.tu8o4EX+fddfuj
  +MrXiwPL5+9cXwrOVvkbxLpomazHbQO7EyX7DpzXYgkFdF6algCQpkX4XUlo
  hA6oa7GWck9w0Gnmy6RXQOoQeCfWwlzsdnHLTq8n9PCHLv7Cxa6PAN3RCKjh
  ISRVZ+sSl704Tqt0kocE9R8J+P+RJOZ4ysp6gN0vppBbOTEN8qp0YCq5bq47
  PUwfA5e766z7NbGMuncw7VgNRSyQhbnPMGrDsGaFSvKM5NcWoIVdZn44.eOi
  9DTRUT.7jDQzSTiF4UzXLc7tLGh4T9pwaFQkGUGIiOOkpBSJUwGsBd40krHQ
  9XEvwq2V6eLIhV6GuzP7uzzXBmzsXPSRYwBtVLp7s5lKVv6UN2VW7xRtYDbx
  7s7wRgHYDI8YVFaTBshkP49R3rYpH3RlUhTQmK5jMadJyF3cYaTNQMGSyhRE
  IIUlJaOOukdhoOyhnekEKmZlqU3UkLrk7bpPrpztKBVUR1uorLddk6xIOqNt
  lBOroRrNVFJGLrDxudpET4kzkstNp2lzuUHVMgk5TDZx9GWumnoQTbhXsEtF
  tzCcM+z0QKXsngCUtTOEIN0SX2iHTTIIz968.Kf.uhfzUCUuAd3UKd.OKt.N
  HTynxTQyjpQD9jlwEXeKQxfHCBahUge6RprSa2V4m3aYOMyaP6gah2Yf1zbD
  jVwZVGFZHHxINFxpjr5CiTS9JiZn6e6nTlXQZTAFj6QCppQwzL0AxVtoi6WE
  QXsANkEGWMEuwNvhmKTnat7A9RqLq6pXuEwY6xM5xRraoTiurj51J1vKLzFs
  CvM7HI14Mpje6YRxHOSieTsJpvJORjxT1nERK6s7YTN7sr6rylNwf5zMiHI4
  meZ4rTYt2PpVettZERbjJ6PjfqN2loPSrUcusH01CegsGEE5467rnCdqT1ES
  QxtCvFq.cvGz+BaAHXKzRSfP+2Jf.KCvj5ZLJRAhwi+SWHvPyN3vXiaPn6JR
  3eoA.0TkFhTvpsDMIrL20nAkCI4EoYfSHAuiPBdmJRyd.IynYYjIzMvjOTKf
  3DLvnvRLDLpWeEOYXMfAZqfQ0.qsnlUdmA33t8CNJ7MZEb.u7fiZHLYzDkJp
  R7CqEVLGN75U+1JXxFUY.xEEBcRCqhOEkz2bENEWnh4pbh0wY25EefbD6EmW
  UA6Ip8wFLyuFXx+Wrp8m6iff1B86W7bqJO9+mx8er4E3.abCLrYdA16sBuHx
  vKT6BlpIGQIhL55W7oicf3ayv3ixQCm4aQuY1HZUPQWY+cASx2WZ3f1fICuz
  vj5R5ZbM1y8gXYN4dIXaYGq4NhQvS5MmcDADy+S.j8CQ78vk7Q7gtPDX3kFh
  3NGaAsYBUAO.8N1U4WKycxbQdrWxJdXd10gNIO+hkUMmm.CZwknu7JbNUYUq
  0sOsTsI1QudDtjw0t+xZ85wWZd80tMCiiMADNX4UzrcSeK23su87IANqmA7j
  tiRzoXi2YRh67ldAk79gPmTe3YKuoY0qdEDV3X8xylCJMTN45JIakB7uY8XW
  uVr3PO8wWwEoTW8lsfraX7ZqzZDDXCRqNkztHsGCYpIDDAOqxDpMVUMKcOrp
  942acPvx2NPocMC1wQZ8glRn3myTykVaEUNLoEeJjVaAevA4EAZnsNgkeyO+
  3rEZB7f0DTazDcQTNmdt8aACGi1QOWnMmd+.6YjMHH19OB5gKsMF877x8wsJ
  hN97JSnSfLUXGUoj6ujWXd6Pk1SAC+Pkogm.tZ.1lX1qL.pe6PE11DPeMMZ2
  .P0K+3peBt3NskC
  -----------end_max5_patcher-----------

*/

]]


examples.Memsic2125 = [[

/*
  Memsic2125

  Read the Memsic 2125 two-axis accelerometer. Converts the pulses output by the
  2125 into milli-g's (1/1000 of Earth's gravity) and prints them over the
  serial connection to the computer.

  The circuit:
	- X output of accelerometer to digital pin 2
	- Y output of accelerometer to digital pin 3
	- +V of accelerometer to +5V
	- GND of accelerometer to ground

  created 6 Nov 2008
  by David A. Mellis
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/sensors/Memsic2125/
*/

// these constants won't change:
const int xPin = 2;  // X output of the accelerometer
const int yPin = 3;  // Y output of the accelerometer

void setup() {
  // initialize serial communications:
  Serial.begin(9600);
  // initialize the pins connected to the accelerometer as inputs:
  pinMode(xPin, INPUT);
  pinMode(yPin, INPUT);
}

void loop() {
  // variables to read the pulse widths:
  int pulseX, pulseY;
  // variables to contain the resulting accelerations
  int accelerationX, accelerationY;

  // read pulse from x- and y-axes:
  pulseX = pulseIn(xPin, HIGH);
  pulseY = pulseIn(yPin, HIGH);

  // convert the pulse width into acceleration
  // accelerationX and accelerationY are in milli-g's:
  // Earth's gravity is 1000 milli-g's, or 1 g.
  accelerationX = ((pulseX / 10) - 500) * 8;
  accelerationY = ((pulseY / 10) - 500) * 8;

  // print the acceleration
  Serial.print(accelerationX);
  // print a tab character:
  Serial.print("\t");
  Serial.print(accelerationY);
  Serial.println();

  delay(100);
}

]]


examples.ADXL3xx = [[

/*
  ADXL3xx

  Reads an Analog Devices ADXL3xx accelerometer and communicates the
  acceleration to the computer. The pins used are designed to be easily
  compatible with the breakout boards from SparkFun, available from:
  https://www.sparkfun.com/categories/80

  The circuit:
  - analog 0: accelerometer self test
  - analog 1: z-axis
  - analog 2: y-axis
  - analog 3: x-axis
  - analog 4: ground
  - analog 5: vcc

  created 2 Jul 2008
  by David A. Mellis
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/sensors/ADXL3xx/
*/

// these constants describe the pins. They won't change:
const int groundpin = 18;  // analog input pin 4 -- ground
const int powerpin = 19;   // analog input pin 5 -- voltage
const int xpin = A3;       // x-axis of the accelerometer
const int ypin = A2;       // y-axis
const int zpin = A1;       // z-axis (only on 3-axis models)

void setup() {
  // initialize the serial communications:
  Serial.begin(9600);

  // Provide ground and power by using the analog inputs as normal digital pins.
  // This makes it possible to directly connect the breakout board to the
  // Arduino. If you use the normal 5V and GND pins on the Arduino,
  // you can remove these lines.
  pinMode(groundpin, OUTPUT);
  pinMode(powerpin, OUTPUT);
  digitalWrite(groundpin, LOW);
  digitalWrite(powerpin, HIGH);
}

void loop() {
  // print the sensor values:
  Serial.print(analogRead(xpin));
  // print a tab between values:
  Serial.print("\t");
  Serial.print(analogRead(ypin));
  // print a tab between values:
  Serial.print("\t");
  Serial.print(analogRead(zpin));
  Serial.println();
  // delay before next reading:
  delay(100);
}

]]


examples.p15_HackingButtons = [[

/*
  Arduino Starter Kit example
  Project 15 - Hacking Buttons

  This sketch is written to accompany Project 15 in the Arduino Starter Kit

  Parts required:
  - battery powered component
  - 220 ohm resistor
  - 4N35 optocoupler

  created 18 Sep 2012
  by Scott Fitzgerald

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

const int optoPin = 2;  // the pin the optocoupler is connected to

void setup() {
  // make the pin with the optocoupler an output
  pinMode(optoPin, OUTPUT);
}

void loop() {
  digitalWrite(optoPin, HIGH);  // pull pin 2 HIGH, activating the optocoupler

  delay(15);  // give the optocoupler a moment to activate

  digitalWrite(optoPin, LOW);  // pull pin 2 low until you're ready to activate again
  delay(21000);                // wait for 21 seconds
}

]]


examples.RowColumnScanning = [[

/*
  Row-Column Scanning an 8x8 LED matrix with X-Y input

  This example controls an 8x8 LED matrix using two analog inputs.

  This example works for the Lumex LDM-24488NI Matrix. See
  https://sigma.octopart.com/140413/datasheet/Lumex-LDM-24488NI.pdf
  for the pin connections.

  For other LED cathode column matrixes, you should only need to change the pin
  numbers in the row[] and column[] arrays.

  rows are the anodes
  cols are the cathodes
  ---------

  Pin numbers:
  Matrix:
  - digital pins 2 through 13,
  - analog pins 2 through 5 used as digital 16 through 19
  Potentiometers:
  - center pins are attached to analog pins 0 and 1, respectively
  - side pins attached to +5V and ground, respectively

  created 27 May 2009
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/display/RowColumnScanning/
*/

// 2-dimensional array of row pin numbers:
const int row[8] = {
  2, 7, 19, 5, 13, 18, 12, 16
};

// 2-dimensional array of column pin numbers:
const int col[8] = {
  6, 11, 10, 3, 17, 4, 8, 9
};

// 2-dimensional array of pixels:
int pixels[8][8];

// cursor position:
int x = 5;
int y = 5;

void setup() {
  // initialize the I/O pins as outputs iterate over the pins:
  for (int thisPin = 0; thisPin < 8; thisPin++) {
    // initialize the output pins:
    pinMode(col[thisPin], OUTPUT);
    pinMode(row[thisPin], OUTPUT);
    // take the col pins (i.e. the cathodes) high to ensure that the LEDS are off:
    digitalWrite(col[thisPin], HIGH);
  }

  // initialize the pixel matrix:
  for (int x = 0; x < 8; x++) {
    for (int y = 0; y < 8; y++) {
      pixels[x][y] = HIGH;
    }
  }
}

void loop() {
  // read input:
  readSensors();

  // draw the screen:
  refreshScreen();
}

void readSensors() {
  // turn off the last position:
  pixels[x][y] = HIGH;
  // read the sensors for X and Y values:
  x = 7 - map(analogRead(A0), 0, 1023, 0, 7);
  y = map(analogRead(A1), 0, 1023, 0, 7);
  // set the new pixel position low so that the LED will turn on in the next
  // screen refresh:
  pixels[x][y] = LOW;
}

void refreshScreen() {
  // iterate over the rows (anodes):
  for (int thisRow = 0; thisRow < 8; thisRow++) {
    // take the row pin (anode) high:
    digitalWrite(row[thisRow], HIGH);
    // iterate over the cols (cathodes):
    for (int thisCol = 0; thisCol < 8; thisCol++) {
      // get the state of the current pixel;
      int thisPixel = pixels[thisRow][thisCol];
      // when the row is HIGH and the col is LOW,
      // the LED where they meet turns on:
      digitalWrite(col[thisCol], thisPixel);
      // turn the pixel off:
      if (thisPixel == LOW) {
        digitalWrite(col[thisCol], HIGH);
      }
    }
    // take the row pin low to turn off the whole row:
    digitalWrite(row[thisRow], LOW);
  }
}

]]


examples.StringIndexOf = [[

/*
  String indexOf() and lastIndexOf() functions

  Examples of how to evaluate, look for, and replace characters in a String

  created 27 Jul 2010
  modified 2 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringIndexOf/
*/

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  // send an intro:
  Serial.println("\n\nString indexOf() and lastIndexOf()  functions:");
  Serial.println();
}

void loop() {
  // indexOf() returns the position (i.e. index) of a particular character in a
  // String. For example, if you were parsing HTML tags, you could use it:
  String stringOne = "<HTML><HEAD><BODY>";
  int firstClosingBracket = stringOne.indexOf('>');
  Serial.println("The index of > in the string " + stringOne + " is " + firstClosingBracket);

  stringOne = "<HTML><HEAD><BODY>";
  int secondOpeningBracket = firstClosingBracket + 1;
  int secondClosingBracket = stringOne.indexOf('>', secondOpeningBracket);
  Serial.println("The index of  the second > in the string " + stringOne + " is " + secondClosingBracket);

  // you can also use indexOf() to search for Strings:
  stringOne = "<HTML><HEAD><BODY>";
  int bodyTag = stringOne.indexOf("<BODY>");
  Serial.println("The index of the body tag in the string " + stringOne + " is " + bodyTag);

  stringOne = "<UL><LI>item<LI>item<LI>item</UL>";
  int firstListItem = stringOne.indexOf("<LI>");
  int secondListItem = stringOne.indexOf("<LI>", firstListItem + 1);
  Serial.println("The index of the second list tag in the string " + stringOne + " is " + secondListItem);

  // lastIndexOf() gives you the last occurrence of a character or string:
  int lastOpeningBracket = stringOne.lastIndexOf('<');
  Serial.println("The index of the last < in the string " + stringOne + " is " + lastOpeningBracket);

  int lastListItem = stringOne.lastIndexOf("<LI>");
  Serial.println("The index of the last list tag in the string " + stringOne + " is " + lastListItem);


  // lastIndexOf() can also search for a string:
  stringOne = "<p>Lorem ipsum dolor sit amet</p><p>Ipsem</p><p>Quod</p>";
  int lastParagraph = stringOne.lastIndexOf("<p");
  int secondLastGraf = stringOne.lastIndexOf("<p", lastParagraph - 1);
  Serial.println("The index of the second to last paragraph tag " + stringOne + " is " + secondLastGraf);

  // do nothing while true:
  while (true)
    ;
}

]]


examples.IfStatementConditional = [[

/*
  Conditionals - If statement

  This example demonstrates the use of if() statements.
  It reads the state of a potentiometer (an analog input) and turns on an LED
  only if the potentiometer goes above a certain threshold level. It prints the
  analog value regardless of the level.

  The circuit:
  - potentiometer
    Center pin of the potentiometer goes to analog pin 0.
    Side pins of the potentiometer go to +5V and ground.
  - LED connected from digital pin 13 to ground through 220 ohm resistor

  - Note: On most Arduino boards, there is already an LED on the board connected
    to pin 13, so you don't need any extra components for this example.

  created 17 Jan 2009
  modified 9 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/control-structures/ifStatementConditional/
*/

// These constants won't change:
const int analogPin = A0;   // pin that the sensor is attached to
const int ledPin = 13;      // pin that the LED is attached to
const int threshold = 400;  // an arbitrary threshold level that's in the range of the analog input

void setup() {
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);
  // initialize serial communications:
  Serial.begin(9600);
}

void loop() {
  // read the value of the potentiometer:
  int analogValue = analogRead(analogPin);

  // if the analog value is high enough, turn on the LED:
  if (analogValue > threshold) {
    digitalWrite(ledPin, HIGH);
  } else {
    digitalWrite(ledPin, LOW);
  }

  // print the analog value:
  Serial.println(analogValue);
  delay(1);  // delay in between reads for stability
}

]]


examples.ReadAnalogVoltage = [[

/*
  Fade

  This example shows how to fade an LED on pin 9 using the analogWrite()
  function.

  The analogWrite() function uses PWM, so if you want to change the pin you're
  using, be sure to use another PWM capable pin. On most Arduino, the PWM pins
  are identified with a "~" sign, like ~3, ~5, ~6, ~9, ~10 and ~11.

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/basics/Fade/
*/

int led = 9;         // the PWM pin the LED is attached to
int brightness = 0;  // how bright the LED is
int fadeAmount = 5;  // how many points to fade the LED by

// the setup routine runs once when you press reset:
void setup() {
  // declare pin 9 to be an output:
  pinMode(led, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  // set the brightness of pin 9:
  analogWrite(led, brightness);

  // change the brightness for next time through the loop:
  brightness = brightness + fadeAmount;

  // reverse the direction of the fading at the ends of the fade:
  if (brightness <= 0 || brightness >= 255) {
    fadeAmount = -fadeAmount;
  }
  // wait for 30 milliseconds to see the dimming effect
  delay(30);
}

]]


examples.p05_ServoMoodIndicator = [[

/*
  Arduino Starter Kit example
  Project 5 - Servo Mood Indicator

  This sketch is written to accompany Project 5 in the Arduino Starter Kit

  Parts required:
  - servo motor
  - 10 kilohm potentiometer
  - two 100 uF electrolytic capacitors

  created 13 Sep 2012
  by Scott Fitzgerald

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

// include the Servo library
#include <Servo.h>

Servo myServo;  // create a servo object

int const potPin = A0;  // analog pin used to connect the potentiometer
int potVal;             // variable to read the value from the analog pin
int angle;              // variable to hold the angle for the servo motor

void setup() {
  myServo.attach(9);   // attaches the servo on pin 9 to the servo object
  Serial.begin(9600);  // open a serial connection to your computer
}

void loop() {
  potVal = analogRead(potPin);  // read the value of the potentiometer
  // print out the value to the Serial Monitor
  Serial.print("potVal: ");
  Serial.print(potVal);

  // scale the numbers from the pot
  angle = map(potVal, 0, 1023, 0, 179);

  // print out the angle for the servo motor
  Serial.print(", angle: ");
  Serial.println(angle);

  // set the servo position
  myServo.write(angle);

  // wait for the servo to get there
  delay(15);
}

]]


examples.StringStartsWithEndsWith = [[

/*
  String startWith() and endsWith()

  Examples of how to use startsWith() and endsWith() in a String

  created 27 Jul 2010
  modified 2 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringStartsWithEndsWith/
*/

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  // send an intro:
  Serial.println("\n\nString startsWith() and endsWith():");
  Serial.println();
}

void loop() {
  // startsWith() checks to see if a String starts with a particular substring:
  String stringOne = "HTTP/1.1 200 OK";
  Serial.println(stringOne);
  if (stringOne.startsWith("HTTP/1.1")) {
    Serial.println("Server's using http version 1.1");
  }

  // you can also look for startsWith() at an offset position in the string:
  stringOne = "HTTP/1.1 200 OK";
  if (stringOne.startsWith("200 OK", 9)) {
    Serial.println("Got an OK from the server");
  }

  // endsWith() checks to see if a String ends with a particular character:
  String sensorReading = "sensor = ";
  sensorReading += analogRead(A0);
  Serial.print(sensorReading);
  if (sensorReading.endsWith("0")) {
    Serial.println(". This reading is divisible by ten");
  } else {
    Serial.println(". This reading is not divisible by ten");
  }

  // do nothing while true:
  while (true)
    ;
}

]]


examples.barGraph = [[

/*
  LED bar graph

  Turns on a series of LEDs based on the value of an analog sensor.
  This is a simple way to make a bar graph display. Though this graph uses 10
  LEDs, you can use any number by changing the LED count and the pins in the
  array.

  This method can be used to control any series of digital outputs that depends
  on an analog input.

  The circuit:
  - LEDs from pins 2 through 11 to ground

  created 4 Sep 2010
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/display/BarGraph/
*/

// these constants won't change:
const int analogPin = A0;  // the pin that the potentiometer is attached to
const int ledCount = 10;   // the number of LEDs in the bar graph

int ledPins[] = {
  2, 3, 4, 5, 6, 7, 8, 9, 10, 11
};  // an array of pin numbers to which LEDs are attached


void setup() {
  // loop over the pin array and set them all to output:
  for (int thisLed = 0; thisLed < ledCount; thisLed++) {
    pinMode(ledPins[thisLed], OUTPUT);
  }
}

void loop() {
  // read the potentiometer:
  int sensorReading = analogRead(analogPin);
  // map the result to a range from 0 to the number of LEDs:
  int ledLevel = map(sensorReading, 0, 1023, 0, ledCount);

  // loop over the LED array:
  for (int thisLed = 0; thisLed < ledCount; thisLed++) {
    // if the array element's index is less than ledLevel,
    // turn the pin for this element on:
    if (thisLed < ledLevel) {
      digitalWrite(ledPins[thisLed], HIGH);
    }
    // turn off all pins higher than the ledLevel:
    else {
      digitalWrite(ledPins[thisLed], LOW);
    }
  }
}

]]


examples.ButtonMouseControl = [[

/*
  ButtonMouseControl

  For Leonardo and Due boards only.

  Controls the mouse from five pushbuttons on an Arduino Leonardo, Micro or Due.

  Hardware:
  - five pushbuttons attached to D2, D3, D4, D5, D6

  The mouse movement is always relative. This sketch reads four pushbuttons,
  and uses them to set the movement of the mouse.

  WARNING: When you use the Mouse.move() command, the Arduino takes over your
  mouse! Make sure you have control before you use the mouse commands.

  created 15 Mar 2012
  modified 27 Mar 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/usb/ButtonMouseControl/
*/

#include "Mouse.h"

// set pin numbers for the five buttons:
const int upButton = 2;
const int downButton = 3;
const int leftButton = 4;
const int rightButton = 5;
const int mouseButton = 6;

int range = 5;           // output range of X or Y movement; affects movement speed
int responseDelay = 10;  // response delay of the mouse, in ms


void setup() {
  // initialize the buttons' inputs:
  pinMode(upButton, INPUT);
  pinMode(downButton, INPUT);
  pinMode(leftButton, INPUT);
  pinMode(rightButton, INPUT);
  pinMode(mouseButton, INPUT);
  // initialize mouse control:
  Mouse.begin();
}

void loop() {
  // read the buttons:
  int upState = digitalRead(upButton);
  int downState = digitalRead(downButton);
  int rightState = digitalRead(rightButton);
  int leftState = digitalRead(leftButton);
  int clickState = digitalRead(mouseButton);

  // calculate the movement distance based on the button states:
  int xDistance = (leftState - rightState) * range;
  int yDistance = (upState - downState) * range;

  // if X or Y is non-zero, move:
  if ((xDistance != 0) || (yDistance != 0)) {
    Mouse.move(xDistance, yDistance, 0);
  }

  // if the mouse button is pressed:
  if (clickState == HIGH) {
    // if the mouse is not pressed, press it:
    if (!Mouse.isPressed(MOUSE_LEFT)) {
      Mouse.press(MOUSE_LEFT);
    }
  }
  // else the mouse button is not pressed:
  else {
    // if the mouse is pressed, release it:
    if (Mouse.isPressed(MOUSE_LEFT)) {
      Mouse.release(MOUSE_LEFT);
    }
  }

  // a delay so the mouse doesn't move too fast:
  delay(responseDelay);
}

]]


examples.p11_CrystalBall = [[

/*
  Arduino Starter Kit example
  Project 11 - Crystal Ball

  This sketch is written to accompany Project 11 in the Arduino Starter Kit

  Parts required:
  - 220 ohm resistor
  - 10 kilohm resistor
  - 10 kilohm potentiometer
  - 16x2 LCD screen
  - tilt switch

  created 13 Sep 2012
  by Scott Fitzgerald

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

// include the library code:
#include <LiquidCrystal.h>

// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(12, 11, 5, 4, 3, 2);

// set up a constant for the tilt switch pin
const int switchPin = 6;

// variable to hold the value of the switch pin
int switchState = 0;

// variable to hold previous value of the switch pin
int prevSwitchState = 0;

// a variable to choose which reply from the crystal ball
int reply;

void setup() {
  // set up the number of columns and rows on the LCD
  lcd.begin(16, 2);

  // set up the switch pin as an input
  pinMode(switchPin, INPUT);

  // Print a message to the LCD.
  lcd.print("Ask the");
  // set the cursor to column 0, line 1
  // line 1 is the second row, since counting begins with 0
  lcd.setCursor(0, 1);
  // print to the second line
  lcd.print("Crystal Ball!");
}

void loop() {
  // check the status of the switch
  switchState = digitalRead(switchPin);

  // compare the switchState to its previous state
  if (switchState != prevSwitchState) {
    // if the state has changed from HIGH to LOW you know that the ball has been
    // tilted from one direction to the other
    if (switchState == LOW) {
      // randomly chose a reply
      reply = random(8);
      // clean up the screen before printing a new reply
      lcd.clear();
      // set the cursor to column 0, line 0
      lcd.setCursor(0, 0);
      // print some text
      lcd.print("the ball says:");
      // move the cursor to the second line
      lcd.setCursor(0, 1);

      // choose a saying to print based on the value in reply
      switch (reply) {
        case 0:
          lcd.print("Yes");
          break;

        case 1:
          lcd.print("Most likely");
          break;

        case 2:
          lcd.print("Certainly");
          break;

        case 3:
          lcd.print("Outlook good");
          break;

        case 4:
          lcd.print("Unsure");
          break;

        case 5:
          lcd.print("Ask again");
          break;

        case 6:
          lcd.print("Doubtful");
          break;

        case 7:
          lcd.print("No");
          break;
      }
    }
  }
  // save the current switch state as the last state
  prevSwitchState = switchState;
}

]]


examples.ForLoopIteration = [[

/*
  For Loop Iteration

  Demonstrates the use of a for() loop.
  Lights multiple LEDs in sequence, then in reverse.

  The circuit:
  - LEDs from pins 2 through 7 to ground

  created 2006
  by David A. Mellis
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/control-structures/ForLoopIteration/
*/

int timer = 100;  // The higher the number, the slower the timing.

void setup() {
  // use a for loop to initialize each pin as an output:
  for (int thisPin = 2; thisPin < 8; thisPin++) {
    pinMode(thisPin, OUTPUT);
  }
}

void loop() {
  // loop from the lowest pin to the highest:
  for (int thisPin = 2; thisPin < 8; thisPin++) {
    // turn the pin on:
    digitalWrite(thisPin, HIGH);
    delay(timer);
    // turn the pin off:
    digitalWrite(thisPin, LOW);
  }

  // loop from the highest pin to the lowest:
  for (int thisPin = 7; thisPin >= 2; thisPin--) {
    // turn the pin on:
    digitalWrite(thisPin, HIGH);
    delay(timer);
    // turn the pin off:
    digitalWrite(thisPin, LOW);
  }
}

]]


examples.tonePitchFollower = [[

/*
  Pitch follower

  Plays a pitch that changes based on a changing analog input

  circuit:
  - 8 ohm speaker on digital pin 9
  - photoresistor on analog 0 to 5V
  - 4.7 kilohm resistor on analog 0 to ground

  created 21 Jan 2010
  modified 31 May 2012
  by Tom Igoe, with suggestion from Michael Flynn

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/digital/tonePitchFollower/
*/

void setup() {
  // initialize serial communications (for debugging only):
  Serial.begin(9600);
}

void loop() {
  // read the sensor:
  int sensorReading = analogRead(A0);
  // print the sensor reading so you know its range
  Serial.println(sensorReading);
  // map the analog input range (in this case, 400 - 1000 from the photoresistor)
  // to the output pitch range (120 - 1500Hz)
  // change the minimum and maximum input numbers below depending on the range
  // your sensor's giving:
  int thisPitch = map(sensorReading, 400, 1000, 120, 1500);

  // play the pitch:
  tone(9, thisPitch, 10);
  delay(1);  // delay in between reads for stability
}

]]


examples.p02_SpaceshipInterface = [[

/*
  Arduino Starter Kit example
  Project 2 - Spaceship Interface

  This sketch is written to accompany Project 2 in the Arduino Starter Kit

  Parts required:
  - one green LED
  - two red LEDs
  - pushbutton
  - 10 kilohm resistor
  - three 220 ohm resistors

  created 13 Sep 2012
  by Scott Fitzgerald

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

// Create a global variable to hold the state of the switch. This variable is
// persistent throughout the program. Whenever you refer to switchState, you’re
// talking about the number it holds
int switchstate = 0;

void setup() {
  // declare the LED pins as outputs
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);

  // declare the switch pin as an input
  pinMode(2, INPUT);
}

void loop() {

  // read the value of the switch
  // digitalRead() checks to see if there is voltage on the pin or not
  switchstate = digitalRead(2);

  // if the button is not pressed turn on the green LED and off the red LEDs
  if (switchstate == LOW) {
    digitalWrite(3, HIGH);  // turn the green LED on pin 3 on
    digitalWrite(4, LOW);   // turn the red LED on pin 4 off
    digitalWrite(5, LOW);   // turn the red LED on pin 5 off
  }
  // this else is part of the above if() statement.
  // if the switch is not LOW (the button is pressed) turn off the green LED and
  // blink alternatively the red LEDs
  else {
    digitalWrite(3, LOW);   // turn the green LED on pin 3 off
    digitalWrite(4, LOW);   // turn the red LED on pin 4 off
    digitalWrite(5, HIGH);  // turn the red LED on pin 5 on
    // wait for a quarter second before changing the light
    delay(250);
    digitalWrite(4, HIGH);  // turn the red LED on pin 4 on
    digitalWrite(5, LOW);   // turn the red LED on pin 5 off
    // wait for a quarter second before changing the light
    delay(250);
  }
}

]]


examples.Midi = [[

/*
  MIDI note player

  This sketch shows how to use the serial transmit pin (pin 1) to send MIDI note data.
  If this circuit is connected to a MIDI synth, it will play the notes
  F#-0 (0x1E) to F#-5 (0x5A) in sequence.

  The circuit:
  - digital in 1 connected to MIDI jack pin 5
  - MIDI jack pin 2 connected to ground
  - MIDI jack pin 4 connected to +5V through 220 ohm resistor
  - Attach a MIDI cable to the jack, then to a MIDI synth, and play music.

  created 13 Jun 2006
  modified 13 Aug 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/communication/Midi/
*/

void setup() {
  // Set MIDI baud rate:
  Serial.begin(31250);
}

void loop() {
  // play notes from F#-0 (0x1E) to F#-5 (0x5A):
  for (int note = 0x1E; note < 0x5A; note++) {
    //Note on channel 1 (0x90), some note value (note), middle velocity (0x45):
    noteOn(0x90, note, 0x45);
    delay(100);
    //Note on channel 1 (0x90), some note value (note), silent velocity (0x00):
    noteOn(0x90, note, 0x00);
    delay(100);
  }
}

// plays a MIDI note. Doesn't check to see that cmd is greater than 127, or that
// data values are less than 127:
void noteOn(int cmd, int pitch, int velocity) {
  Serial.write(cmd);
  Serial.write(pitch);
  Serial.write(velocity);
}

]]


examples.Arrays = [[

/*
  Arrays

  Demonstrates the use of an array to hold pin numbers in order to iterate over
  the pins in a sequence. Lights multiple LEDs in sequence, then in reverse.

  Unlike the For Loop tutorial, where the pins have to be contiguous, here the
  pins can be in any random order.

  The circuit:
  - LEDs from pins 2 through 7 to ground

  created 2006
  by David A. Mellis
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/control-structures/Arrays/
*/

int timer = 100;  // The higher the number, the slower the timing.
int ledPins[] = {
  2, 7, 4, 6, 5, 3
};                 // an array of pin numbers to which LEDs are attached
int pinCount = 6;  // the number of pins (i.e. the length of the array)

void setup() {
  // the array elements are numbered from 0 to (pinCount - 1).
  // use a for loop to initialize each pin as an output:
  for (int thisPin = 0; thisPin < pinCount; thisPin++) {
    pinMode(ledPins[thisPin], OUTPUT);
  }
}

void loop() {
  // loop from the lowest pin to the highest:
  for (int thisPin = 0; thisPin < pinCount; thisPin++) {
    // turn the pin on:
    digitalWrite(ledPins[thisPin], HIGH);
    delay(timer);
    // turn the pin off:
    digitalWrite(ledPins[thisPin], LOW);
  }

  // loop from the highest pin to the lowest:
  for (int thisPin = pinCount - 1; thisPin >= 0; thisPin--) {
    // turn the pin on:
    digitalWrite(ledPins[thisPin], HIGH);
    delay(timer);
    // turn the pin off:
    digitalWrite(ledPins[thisPin], LOW);
  }
}

]]


examples.Knock = [[

/*
  Knock Sensor

  This sketch reads a piezo element to detect a knocking sound.
  It reads an analog pin and compares the result to a set threshold.
  If the result is greater than the threshold, it writes "knock" to the serial
  port, and toggles the LED on pin 13.

  The circuit:
	- positive connection of the piezo attached to analog in 0
	- negative connection of the piezo attached to ground
	- 1 megohm resistor attached from analog in 0 to ground

  created 25 Mar 2007
  by David Cuartielles <http://www.0j0.org>
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/sensors/Knock/
*/


// these constants won't change:
const int ledPin = 13;       // LED connected to digital pin 13
const int knockSensor = A0;  // the piezo is connected to analog pin 0
const int threshold = 100;   // threshold value to decide when the detected sound is a knock or not


// these variables will change:
int sensorReading = 0;  // variable to store the value read from the sensor pin
int ledState = LOW;     // variable used to store the last LED status, to toggle the light

void setup() {
  pinMode(ledPin, OUTPUT);  // declare the ledPin as as OUTPUT
  Serial.begin(9600);       // use the serial port
}

void loop() {
  // read the sensor and store it in the variable sensorReading:
  sensorReading = analogRead(knockSensor);

  // if the sensor reading is greater than the threshold:
  if (sensorReading >= threshold) {
    // toggle the status of the ledPin:
    ledState = !ledState;
    // update the LED pin itself:
    digitalWrite(ledPin, ledState);
    // send the string "Knock!" back to the computer, followed by newline
    Serial.println("Knock!");
  }
  delay(100);  // delay to avoid overloading the serial port buffer
}

]]


examples.p09_MotorizedPinwheel = [[

/*
  Arduino Starter Kit example
  Project 9 - Motorized Pinwheel

  This sketch is written to accompany Project 9 in the Arduino Starter Kit

  Parts required:
  - 10 kilohm resistor
  - pushbutton
  - motor
  - 9V battery
  - IRF520 MOSFET
  - 1N4007 diode

  created 13 Sep 2012
  by Scott Fitzgerald

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

// named constants for the switch and motor pins
const int switchPin = 2;  // the number of the switch pin
const int motorPin = 9;   // the number of the motor pin

int switchState = 0;  // variable for reading the switch's status

void setup() {
  // initialize the motor pin as an output:
  pinMode(motorPin, OUTPUT);
  // initialize the switch pin as an input:
  pinMode(switchPin, INPUT);
}

void loop() {
  // read the state of the switch value:
  switchState = digitalRead(switchPin);

  // check if the switch is pressed.
  if (switchState == HIGH) {
    // turn motor on:
    digitalWrite(motorPin, HIGH);
  } else {
    // turn motor off:
    digitalWrite(motorPin, LOW);
  }
}

]]


examples.p03_LoveOMeter = [[

/*
  Arduino Starter Kit example
  Project 3 - Love-O-Meter

  This sketch is written to accompany Project 3 in the Arduino Starter Kit

  Parts required:
  - one TMP36 temperature sensor
  - three red LEDs
  - three 220 ohm resistors

  created 13 Sep 2012
  by Scott Fitzgerald

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

// named constant for the pin the sensor is connected to
const int sensorPin = A0;
// room temperature in Celsius
const float baselineTemp = 20.0;

void setup() {
  // open a serial connection to display values
  Serial.begin(9600);
  // set the LED pins as outputs
  // the for() loop saves some extra coding
  for (int pinNumber = 2; pinNumber < 5; pinNumber++) {
    pinMode(pinNumber, OUTPUT);
    digitalWrite(pinNumber, LOW);
  }
}

void loop() {
  // read the value on AnalogIn pin 0 and store it in a variable
  int sensorVal = analogRead(sensorPin);

  // send the 10-bit sensor value out the serial port
  Serial.print("sensor Value: ");
  Serial.print(sensorVal);

  // convert the ADC reading to voltage
  float voltage = (sensorVal / 1024.0) * 5.0;

  // Send the voltage level out the Serial port
  Serial.print(", Volts: ");
  Serial.print(voltage);

  // convert the voltage to temperature in degrees C
  // the sensor changes 10 mV per degree
  // the datasheet says there's a 500 mV offset
  // ((voltage - 500 mV) times 100)
  Serial.print(", degrees C: ");
  float temperature = (voltage - .5) * 100;
  Serial.println(temperature);

  // if the current temperature is lower than the baseline turn off all LEDs
  if (temperature < baselineTemp + 2) {
    digitalWrite(2, LOW);
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
  }  // if the temperature rises 2-4 degrees, turn an LED on
  else if (temperature >= baselineTemp + 2 && temperature < baselineTemp + 4) {
    digitalWrite(2, HIGH);
    digitalWrite(3, LOW);
    digitalWrite(4, LOW);
  }  // if the temperature rises 4-6 degrees, turn a second LED on
  else if (temperature >= baselineTemp + 4 && temperature < baselineTemp + 6) {
    digitalWrite(2, HIGH);
    digitalWrite(3, HIGH);
    digitalWrite(4, LOW);
  }  // if the temperature rises more than 6 degrees, turn all LEDs on
  else if (temperature >= baselineTemp + 6) {
    digitalWrite(2, HIGH);
    digitalWrite(3, HIGH);
    digitalWrite(4, HIGH);
  }
  delay(1);
}

]]


examples.Fade = [[

/*
  Fade

  This example shows how to fade an LED on pin 9 using the analogWrite()
  function.

  The analogWrite() function uses PWM, so if you want to change the pin you're
  using, be sure to use another PWM capable pin. On most Arduino, the PWM pins
  are identified with a "~" sign, like ~3, ~5, ~6, ~9, ~10 and ~11.

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/basics/Fade/
*/

int led = 9;         // the PWM pin the LED is attached to
int brightness = 0;  // how bright the LED is
int fadeAmount = 5;  // how many points to fade the LED by

// the setup routine runs once when you press reset:
void setup() {
  // declare pin 9 to be an output:
  pinMode(led, OUTPUT);
}

// the loop routine runs over and over again forever:
void loop() {
  // set the brightness of pin 9:
  analogWrite(led, brightness);

  // change the brightness for next time through the loop:
  brightness = brightness + fadeAmount;

  // reverse the direction of the fading at the ends of the fade:
  if (brightness <= 0 || brightness >= 255) {
    fadeAmount = -fadeAmount;
  }
  // wait for 30 milliseconds to see the dimming effect
  delay(30);
}

]]


examples.AnalogWriteMega = [[

/*
  Mega analogWrite() test

  This sketch fades LEDs up and down one at a time on digital pins 2 through 13.
  This sketch was written for the Arduino Mega, and will not work on other boards.

  The circuit:
  - LEDs attached from pins 2 through 13 to ground.

  created 8 Feb 2009
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/analog/AnalogWriteMega/
*/

// These constants won't change. They're used to give names to the pins used:
const int lowestPin = 2;
const int highestPin = 13;


void setup() {
  // set pins 2 through 13 as outputs:
  for (int thisPin = lowestPin; thisPin <= highestPin; thisPin++) {
    pinMode(thisPin, OUTPUT);
  }
}

void loop() {
  // iterate over the pins:
  for (int thisPin = lowestPin; thisPin <= highestPin; thisPin++) {
    // fade the LED on thisPin from off to brightest:
    for (int brightness = 0; brightness < 255; brightness++) {
      analogWrite(thisPin, brightness);
      delay(2);
    }
    // fade the LED on thisPin from brightest to off:
    for (int brightness = 255; brightness >= 0; brightness--) {
      analogWrite(thisPin, brightness);
      delay(2);
    }
    // pause between LEDs:
    delay(100);
  }
}

]]


examples.StringAdditionOperator = [[

/*
  Adding Strings together

  Examples of how to add Strings together
  You can also add several different data types to String, as shown here:

  created 27 Jul 2010
  modified 2 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringAdditionOperator/
*/

// declare three Strings:
String stringOne, stringTwo, stringThree;

void setup() {
  // initialize serial and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  stringOne = String("You added ");
  stringTwo = String("this string");
  stringThree = String();
  // send an intro:
  Serial.println("\n\nAdding Strings together (concatenation):");
  Serial.println();
}

void loop() {
  // adding a constant integer to a String:
  stringThree = stringOne + 123;
  Serial.println(stringThree);  // prints "You added 123"

  // adding a constant long integer to a String:
  stringThree = stringOne + 123456789;
  Serial.println(stringThree);  // prints "You added 123456789"

  // adding a constant character to a String:
  stringThree = stringOne + 'A';
  Serial.println(stringThree);  // prints "You added A"

  // adding a constant string to a String:
  stringThree = stringOne + "abc";
  Serial.println(stringThree);  // prints "You added abc"

  stringThree = stringOne + stringTwo;
  Serial.println(stringThree);  // prints "You added this string"

  // adding a variable integer to a String:
  int sensorValue = analogRead(A0);
  stringOne = "Sensor value: ";
  stringThree = stringOne + sensorValue;
  Serial.println(stringThree);  // prints "Sensor Value: 401" or whatever value analogRead(A0) has

  // adding a variable long integer to a String:
  stringOne = "millis() value: ";
  stringThree = stringOne + millis();
  Serial.println(stringThree);  // prints "The millis: 345345" or whatever value millis() has

  // do nothing while true:
  while (true)
    ;
}

]]


examples.AnalogInput = [[

/*
  Analog Input

  Demonstrates analog input by reading an analog sensor on analog pin 0 and
  turning on and off a light emitting diode(LED) connected to digital pin 13.
  The amount of time the LED will be on and off depends on the value obtained
  by analogRead().

  The circuit:
  - potentiometer
    center pin of the potentiometer to the analog input 0
    one side pin (either one) to ground
    the other side pin to +5V
  - LED
    anode (long leg) attached to digital output 13 through 220 ohm resistor
    cathode (short leg) attached to ground

  - Note: because most Arduinos have a built-in LED attached to pin 13 on the
    board, the LED is optional.

  created by David Cuartielles
  modified 30 Aug 2011
  By Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/analog/AnalogInput/
*/

int sensorPin = A0;   // select the input pin for the potentiometer
int ledPin = 13;      // select the pin for the LED
int sensorValue = 0;  // variable to store the value coming from the sensor

void setup() {
  // declare the ledPin as an OUTPUT:
  pinMode(ledPin, OUTPUT);
}

void loop() {
  // read the value from the sensor:
  sensorValue = analogRead(sensorPin);
  // turn the ledPin on
  digitalWrite(ledPin, HIGH);
  // stop the program for <sensorValue> milliseconds:
  delay(sensorValue);
  // turn the ledPin off:
  digitalWrite(ledPin, LOW);
  // stop the program for <sensorValue> milliseconds:
  delay(sensorValue);
}

]]


examples.toneKeyboard = [[

/*
  Keyboard

  Plays a pitch that changes based on a changing analog input

  circuit:
  - three force-sensing resistors from +5V to analog in 0 through 5
  - three 10 kilohm resistors from analog in 0 through 5 to ground
  - 8 ohm speaker on digital pin 8

  created 21 Jan 2010
  modified 9 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/digital/toneKeyboard/
*/

#include "pitches.h"

const int threshold = 10;  // minimum reading of the sensors that generates a note

// notes to play, corresponding to the 3 sensors:
int notes[] = {
  NOTE_A4, NOTE_B4, NOTE_C3
};

void setup() {
}

void loop() {
  for (int thisSensor = 0; thisSensor < 3; thisSensor++) {
    // get a sensor reading:
    int sensorReading = analogRead(thisSensor);

    // if the sensor is pressed hard enough:
    if (sensorReading > threshold) {
      // play the note corresponding to this sensor:
      tone(8, notes[thisSensor], 20);
    }
  }
}

]]


examples.Blink = [[

/*
  Blink

  Turns an LED on for one second, then off for one second, repeatedly.

  Most Arduinos have an on-board LED you can control. On the UNO, MEGA and ZERO
  it is attached to digital pin 13, on MKR1000 on pin 6. LED_BUILTIN is set to
  the correct LED pin independent of which board is used.
  If you want to know what pin the on-board LED is connected to on your Arduino
  model, check the Technical Specs of your board at:
  https://docs.arduino.cc/hardware/

  modified 8 May 2014
  by Scott Fitzgerald
  modified 2 Sep 2016
  by Arturo Guadalupi
  modified 8 Sep 2016
  by Colby Newman

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/basics/Blink/
*/

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  digitalWrite(LED_BUILTIN, HIGH);  // turn the LED on (HIGH is the voltage level)
  delay(1000);                      // wait for a second
  digitalWrite(LED_BUILTIN, LOW);   // turn the LED off by making the voltage LOW
  delay(1000);                      // wait for a second
}

]]


examples.ReadASCIIString = [[

/*
  Reading a serial ASCII-encoded string.

  This sketch demonstrates the Serial parseInt() function.
  It looks for an ASCII string of comma-separated values.
  It parses them into ints, and uses those to fade an RGB LED.

  Circuit: Common-Cathode RGB LED wired like so:
  - red anode: digital pin 3 through 220 ohm resistor
  - green anode: digital pin 5 through 220 ohm resistor
  - blue anode: digital pin 6 through 220 ohm resistor
  - cathode: GND

  created 13 Apr 2012
  by Tom Igoe
  modified 14 Mar 2016
  by Arturo Guadalupi

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/communication/ReadASCIIString/
*/

// pins for the LEDs:
const int redPin = 3;
const int greenPin = 5;
const int bluePin = 6;

void setup() {
  // initialize serial:
  Serial.begin(9600);
  // make the pins outputs:
  pinMode(redPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
}

void loop() {
  // if there's any serial available, read it:
  while (Serial.available() > 0) {

    // look for the next valid integer in the incoming serial stream:
    int red = Serial.parseInt();
    // do it again:
    int green = Serial.parseInt();
    // do it again:
    int blue = Serial.parseInt();

    // look for the newline. That's the end of your sentence:
    if (Serial.read() == '\n') {
      // constrain the values to 0 - 255 and invert
      // if you're using a common-cathode LED, just use "constrain(color, 0, 255);"
      red = 255 - constrain(red, 0, 255);
      green = 255 - constrain(green, 0, 255);
      blue = 255 - constrain(blue, 0, 255);

      // fade the red, green, and blue legs of the LED:
      analogWrite(redPin, red);
      analogWrite(greenPin, green);
      analogWrite(bluePin, blue);

      // print the three numbers in one string as hexadecimal:
      Serial.print(red, HEX);
      Serial.print(green, HEX);
      Serial.println(blue, HEX);
    }
  }
}

]]


examples.StringToInt = [[

/*
  String to Integer conversion

  Reads a serial input string until it sees a newline, then converts the string
  to a number if the characters are digits.

  The circuit:
  - No external components needed.

  created 29 Nov 2010
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringToInt/
*/

String inString = "";  // string to hold input

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  // send an intro:
  Serial.println("\n\nString toInt():");
  Serial.println();
}

void loop() {
  // Read serial input:
  while (Serial.available() > 0) {
    int inChar = Serial.read();
    if (isDigit(inChar)) {
      // convert the incoming byte to a char and add it to the string:
      inString += (char)inChar;
    }
    // if you get a newline, print the string, then the string's value:
    if (inChar == '\n') {
      Serial.print("Value:");
      Serial.println(inString.toInt());
      Serial.print("String: ");
      Serial.println(inString);
      // clear the string for new input:
      inString = "";
    }
  }
}

]]


examples.CharacterAnalysis = [[

/*
  Character analysis operators

  Examples using the character analysis operators.
  Send any byte and the sketch will tell you about it.

  created 29 Nov 2010
  modified 2 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/CharacterAnalysis/
*/

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  // send an intro:
  Serial.println("send any byte and I'll tell you everything I can about it");
  Serial.println();
}

void loop() {
  // get any incoming bytes:
  if (Serial.available() > 0) {
    int thisChar = Serial.read();

    // say what was sent:
    Serial.print("You sent me: \'");
    Serial.write(thisChar);
    Serial.print("\'  ASCII Value: ");
    Serial.println(thisChar);

    // analyze what was sent:
    if (isAlphaNumeric(thisChar)) {
      Serial.println("it's alphanumeric");
    }
    if (isAlpha(thisChar)) {
      Serial.println("it's alphabetic");
    }
    if (isAscii(thisChar)) {
      Serial.println("it's ASCII");
    }
    if (isWhitespace(thisChar)) {
      Serial.println("it's whitespace");
    }
    if (isControl(thisChar)) {
      Serial.println("it's a control character");
    }
    if (isDigit(thisChar)) {
      Serial.println("it's a numeric digit");
    }
    if (isGraph(thisChar)) {
      Serial.println("it's a printable character that's not whitespace");
    }
    if (isLowerCase(thisChar)) {
      Serial.println("it's lower case");
    }
    if (isPrintable(thisChar)) {
      Serial.println("it's printable");
    }
    if (isPunct(thisChar)) {
      Serial.println("it's punctuation");
    }
    if (isSpace(thisChar)) {
      Serial.println("it's a space character");
    }
    if (isUpperCase(thisChar)) {
      Serial.println("it's upper case");
    }
    if (isHexadecimalDigit(thisChar)) {
      Serial.println("it's a valid hexadecimaldigit (i.e. 0 - 9, a - F, or A - F)");
    }

    // add some space and ask for another byte:
    Serial.println();
    Serial.println("Give me another byte:");
    Serial.println();
  }
}

]]


examples.p08_DigitalHourglass = [[

/*
  Arduino Starter Kit example
  Project 8 - Digital Hourglass

  This sketch is written to accompany Project 8 in the Arduino Starter Kit

  Parts required:
  - 10 kilohm resistor
  - six 220 ohm resistors
  - six LEDs
  - tilt switch

  created 13 Sep 2012
  by Scott Fitzgerald

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

// named constant for the switch pin
const int switchPin = 8;

unsigned long previousTime = 0;  // store the last time an LED was updated
int switchState = 0;             // the current switch state
int prevSwitchState = 0;         // the previous switch state
int led = 2;                     // a variable to refer to the LEDs

// 600000 = 10 minutes in milliseconds
long interval = 600000;  // interval at which to light the next LED

void setup() {
  // set the LED pins as outputs
  for (int x = 2; x < 8; x++) {
    pinMode(x, OUTPUT);
  }
  // set the tilt switch pin as input
  pinMode(switchPin, INPUT);
}

void loop() {
  // store the time since the Arduino started running in a variable
  unsigned long currentTime = millis();

  // compare the current time to the previous time an LED turned on
  // if it is greater than your interval, run the if statement
  if (currentTime - previousTime > interval) {
    // save the current time as the last time you changed an LED
    previousTime = currentTime;
    // Turn the LED on
    digitalWrite(led, HIGH);
    // increment the led variable
    // in 10 minutes the next LED will light up
    led++;

    if (led == 7) {
      // the hour is up
    }
  }

  // read the switch value
  switchState = digitalRead(switchPin);

  // if the switch has changed
  if (switchState != prevSwitchState) {
    // turn all the LEDs low
    for (int x = 2; x < 8; x++) {
      digitalWrite(x, LOW);
    }

    // reset the LED variable to the first one
    led = 2;

    //reset the timer
    previousTime = currentTime;
  }
  // set the previous switch state to the current state
  prevSwitchState = switchState;
}

]]


examples.p13_TouchSensorLamp = [[

/*
  Arduino Starter Kit example
  Project 13 - Touch Sensor Lamp

  This sketch is written to accompany Project 13 in the Arduino Starter Kit

  Parts required:
  - 1 megohm resistor
  - metal foil or copper mesh
  - 220 ohm resistor
  - LED

  Software required :
  - CapacitiveSensor library by Paul Badger
    https://www.arduino.cc/reference/en/libraries/capacitivesensor/

  created 18 Sep 2012
  by Scott Fitzgerald

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

// import the library (must be located in the Arduino/libraries directory)
#include <CapacitiveSensor.h>

// create an instance of the library
// pin 4 sends electrical energy
// pin 2 senses senses a change
CapacitiveSensor capSensor = CapacitiveSensor(4, 2);

// threshold for turning the lamp on
int threshold = 1000;

// pin the LED is connected to
const int ledPin = 12;


void setup() {
  // open a serial connection
  Serial.begin(9600);
  // set the LED pin as an output
  pinMode(ledPin, OUTPUT);
}

void loop() {
  // store the value reported by the sensor in a variable
  long sensorValue = capSensor.capacitiveSensor(30);

  // print out the sensor value
  Serial.println(sensorValue);

  // if the value is greater than the threshold
  if (sensorValue > threshold) {
    // turn the LED on
    digitalWrite(ledPin, HIGH);
  }
  // if it's lower than the threshold
  else {
    // turn the LED off
    digitalWrite(ledPin, LOW);
  }

  delay(10);
}

]]


examples.SerialCallResponseASCII = [[

/*
  Serial Call and Response in ASCII
  Language: Wiring/Arduino

  This program sends an ASCII A (byte of value 65) on startup and repeats that
  until it gets some data in. Then it waits for a byte in the serial port, and
  sends three ASCII-encoded, comma-separated sensor values, truncated by a
  linefeed and carriage return, whenever it gets a byte in.

  The circuit:
  - potentiometers attached to analog inputs 0 and 1
  - pushbutton attached to digital I/O 2

  created 26 Sep 2005
  by Tom Igoe
  modified 24 Apr 2012
  by Tom Igoe and Scott Fitzgerald
  Thanks to Greg Shakar and Scott Fitzgerald for the improvements

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/communication/SerialCallResponseASCII/
*/

int firstSensor = 0;   // first analog sensor
int secondSensor = 0;  // second analog sensor
int thirdSensor = 0;   // digital sensor
int inByte = 0;        // incoming serial byte

void setup() {
  // start serial port at 9600 bps and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }


  pinMode(2, INPUT);   // digital sensor is on digital pin 2
  establishContact();  // send a byte to establish contact until receiver responds
}

void loop() {
  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    // read first analog input:
    firstSensor = analogRead(A0);
    // read second analog input:
    secondSensor = analogRead(A1);
    // read switch, map it to 0 or 255
    thirdSensor = map(digitalRead(2), 0, 1, 0, 255);
    // send sensor values:
    Serial.print(firstSensor);
    Serial.print(",");
    Serial.print(secondSensor);
    Serial.print(",");
    Serial.println(thirdSensor);
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("0,0,0");  // send an initial string
    delay(300);
  }
}

/* Processing code to run with this example:

  // This example code is in the public domain.

  import processing.serial.*;     // import the Processing serial library
  Serial myPort;                  // The serial port

  float bgcolor;      // Background color
  float fgcolor;      // Fill color
  float xpos, ypos;         // Starting position of the ball

  void setup() {
    size(640, 480);

    // List all the available serial ports
    // if using Processing 2.1 or later, use Serial.printArray()
    println(Serial.list());

    // I know that the first port in the serial list on my Mac is always my
    // Arduino board, so I open Serial.list()[0].
    // Change the 0 to the appropriate number of the serial port that your
    // microcontroller is attached to.
    myPort = new Serial(this, Serial.list()[0], 9600);

    // read bytes into a buffer until you get a linefeed (ASCII 10):
    myPort.bufferUntil('\n');

    // draw with smooth edges:
    smooth();
  }

  void draw() {
    background(bgcolor);
    fill(fgcolor);
    // Draw the shape
    ellipse(xpos, ypos, 20, 20);
  }

  // serialEvent method is run automatically by the Processing applet whenever
  // the buffer reaches the  byte value set in the bufferUntil()
  // method in the setup():

  void serialEvent(Serial myPort) {
    // read the serial buffer:
    String myString = myPort.readStringUntil('\n');
    // if you got any bytes other than the linefeed:
    myString = trim(myString);

    // split the string at the commas and convert the sections into integers:
    int sensors[] = int(split(myString, ','));

    // print out the values you got:
    for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
      print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t");
    }
    // add a linefeed after all the sensor values are printed:
    println();
    if (sensors.length > 1) {
      xpos = map(sensors[0], 0, 1023, 0, width);
      ypos = map(sensors[1], 0, 1023, 0, height);
      fgcolor = sensors[2];
    }
    // send a byte to ask for more data:
    myPort.write("A");
  }

*/

/* Max/MSP version 5 patch to run with this example:

  ----------begin_max5_patcher----------
  3640.3oc6cs0jZajE94Y9UzKkeHoVloTeSHkm1II0VkeHIthSs6C1obIjZ.E
  KjHRhY7jT4+9d5KBj.jTCAXfoV6x.sj5VmyWet127ed6MCFm8EQw.z2f9.5l
  a9yau4F0kjW3FS4aFLO3KgIAEpGaPX174hzxAC02qT7kR80mkkUHPAnBQdbP
  BZQVdIZRd1bT4r3BDTmkU0YQPY3r3zoeJWDVpe2ttr6cFhvXt7KhyH8W26f9
  USkhiTulrw+1czQUszjrzxzf4B0sdP9dqtS5x4woIhREQiWewrkkUW0oViTD
  +GpFASt2Qd0+51akeLzRPIU7DPXagIFnH.4653f9WAKKyxVHRQNcfDXlih2w
  puvbdWHAlcTPBRKHg4x5mr74EBMINHV1+iFL.8qG.VMWTTDLUrs.TBH+zAvP
  nTEhvvxun9pBd6FWH38DWH6DWv6ItbX.RKBOJ7XbP5ztvDesvhBLb6VTwcOg
  DmiBjnXfiIrjjED0CpP490PEmtPExwQA5EGUVjK.CKQJqtcYl0nCMRAJi76D
  Z7dQflCCVV1i+ENiTy3AwYaghEA4.KVJx+jHMXbhntJPceO3iBpPOPKtZqtU
  jUoXtw28fkEimmEIlOI.3Q4iMT9wO+iLxc9O7sN28928t6Ve8uMYo.7EUN6t
  ePVoUW+6E4hOW7CAgeaV1meWd1cuWnYLy8mKhhClGDd25F3ce+C2si1Ud42+
  bZ3IQJOXg7q96t80e50YvDjqHw7VvkRTXhHHuKEerRwmqfBFsS.g9h.HZN3X
  hJf5Qd+xHZHgzc.mrqeYjbn4E84evfIDUjDtjNwD2iRHV6anmGdbmsfKxTTJ
  dd93rjtBJ2U42foCwZDqKfYzKkrh4VgYIY4FxVRmN2646f8ck+xw7KrjzOlZ
  ZYAVfdZgKlaWn29FzA8nfdR2quj.3ejflBJnKr.Dwpf13cZBm85P0rPj.rOB
  6fvztPFGkVI0SAPi5NKHmih7E8Ph2e35uOtYN6x6JEQtJVWpV7gRtm2dZy9W
  +YMCxLHrEvAknQktDVdY7v82SFosgmSGHO56BRRt6mEEKxRKDnGd+2812h9X
  5GSeODOcAJ.M9YHHAfjPkyD0GIugn.Ht6bQ.7TTS8DoPtCQCQxWobX+jYPUJ
  hPn3zgnx7kogphieFZ2j3TwDgH5dzaUscJ77kEnIY4hoYKglVYzcH5KKxJzu
  qmgegxl.0MLNGBNDsr.5IUz0iAPZFE.0TtLOEdClQYrAAeORwW+XVo3aP+hb
  DHUBCH.mfbEKfGOPyjQhGiCAdNUUBRcQjij4X.u5MZRDzHSyTDQFbcYdHHIM
  AzlF1lnoLjKG8UZH5guV1vEkA4kKWbOPGPC9YgjNdJHVy+ZJQ1.Cq.FUWQpA
  ke.8DbUwi.YEWBUCDhPyAXCEETFbuhICg9EIRiYnGVjKyt0+io.r+9vrxRz+
  Nt7OlJxCRhT35u.X0amlI9X5xEQppQwneJrLarPVU7JkGYWVHz2njevz1UoX
  XkoEWOkxDWO9kXYocoTwuzF611zXJyimB3F5qf9nOT9qesryJTJ1EOcV4cIh
  IPVWYoOBUMFTl.4sGRRzRT4AOIkRjn8h7LnNJI2mhg6OSk5JZrPJ4i9gfu.R
  w+NHLCcpfAMij88n+qTPPMt4UTwj3bAnY.h.aIe.RiAEeF8Pdzx3zLkLUs1Z
  mcmczah0FH4ZmpLcp.rVbX3d0zalKhSiKAxBZ9BU2zTP3uPobgL1Q.U0.kl+
  jcBZj1AMOpzsJYjdz0n53QXsfYrqELKblH7yUFoDfPVXbrwDGXqCjwjviT7a
  rXZbpxOvxzXvpOnPH0GlTJMZog8l2UZJcdPjxjG7ywIYgeFULaInFDk8jpxZ
  apvMA4cv9X.7.vaRRGFAcPYHMR0dF2BZC7wEJ2TOKeZnCRD+HzJo.OLWSW6r
  qk2wfI6pGf.pdjC4rpfL2YeK8JYloVf93.ocJEvocv9wAcEiMQgBtl.lb0y9
  heKnvtGRs+iHOJHM3uaZbN1jDrhED4FfwfLPCEmH8jV.BB0Z+aF.Vkqc4apU
  EIb9a5zAcGt5Rf3WdsNJ3R4PXDU0mouHzIca0MWO.KpQjT8oq1SIyqV3mP24
  ToxfHpdyOPNqgwoK.W.fxfRNtwsiDSBVlT9ociSMu+jfPQqUtk9paFLMONJK
  URFMpq7xUuvOXF1HBuN6ndhzfE6nxPXQkKKFGjKQNyHtSptYYVVRyaspyBD3
  CRiA0YQYrlbgHdptY77E4wZk5UWSOf9yJByyRRZzT5673NtiNrvmhiJmoZq5
  fI73wKp5DFrBihhmBNxadsxfoEMuRiIbutfVcM4FWuyr.2bvrlNF5.3U+q9C
  sKaa5jkMt70iSd8bC2ZbEFUuAa0DWqYF0tJ91p43649br2nZ2usLGuoxrnQq
  6TArNx+1CjRLPpVWf62Kj59ZFRa38Y6D0kRo8AnT8b0g0e4p8+f6.P4sBnaX
  TqMmPsOdOcjG+dMtOmdzcgLdIGqjX0J+FAVrmSu.L8fAX19Ky1C.e1.z+IB2
  qpeCIUV+.I4fARxQGH0i.9ECVZrhZMTheMCkc4XRMsoCgbef2ZFjaF5MXzaH
  n2PQugYmhe0WjdcU47Z1Ukhb6CwFISy2HNtcvtaNRWdshHNVgHcNMUlopRm4
  tJByyLXfI0UN6GM7eUiFTm8BMbctZQC8atOegDu6oveXrgpeaGnfaETvsBJN
  6AKuNsT4n+zRVXJtQd+ciEEYKyCq.8ptRTSdBRQrLNcUd5eXcjoa7fyhihZl
  UrNQxBYZo5g.vpdt8klkJi1QyPvdH7UFMStbvYu8Amu1nY7ECMKGXBqnY2KH
  Z18Jjl4aYNnEYiQWVzrUxytWNzL0VZ14xglI6isN5kAMi2GZlbYPyNma6FqC
  aJRs9qEogO+ovfvYFxxjGV07cLnH3QQzm.R.BG7SAkk4wiWVpC2p9jwX23ka
  0zSz4M6e1QZY.8mljMNHwLURqZ9FuzslMk8ZJXtcMPeblVut1XYDhdMCpmjZ
  8BAqsU9DezKxJAa8Hmbbfi+wccuVv7c0qELrEHB+UAhHWzCfCbKPEyBki24Z
  clythVwfkYSmlHrPdX8tC5v1iPb5ArPuOWc8NVrRZspq24UxhE0wBcAsMyt2
  2LLuqvkKZRXjEq5CM6S3tq9Zm6HD+8Prm0F+jDWn1paUe+2ZuF259kxkiR5W
  Qf6vzKBtMm+gFrMeuWsKW.6B61VyWOFjz0Zsmwza+.ikxQcAL3iDtbLWMTKm
  OtyMEFcjWM9iu0rMa81D8kUl3v2ewcHWP5B2HX6kK7t7DL5fs6JVIrO0Z1l3
  bEpOP3zih9.gbspPzKDYbRVAQ7CFhtZsYzhW1ko0WEJcG3oAC0aRIyxKsUEI
  +iDPwOLfp0uNA68MmtSUSmRuNb8d1ttWya7sVWf5Iwf.1LQtZUnqNvT1bS6z
  E5o2vfqNSH5bufQbuZV09M.E04Mj8XBUiBqNGl5FSt3NGlZaGRpV6wc4kiWi
  q0twaaORhul1jjsIi7cMjQlJJUaQuhR495nlfRQWRJXkrgmMGXWjKM4jdGJH
  yovkl4HUetutzWuY5tjFHneGn77rtG3iJ92whCVJxKhBwgGtRaFIzabfNrRn
  WThd9q24vsZjf9JvHwOKBhprFDmtXYIZ7xISjaO1GE4OK2V9yiS.qFhvrznh
  8cKyMZs7EVepT01FlCe0rIC0lUk6NX4N9syCyAE660+ovE9hyGqjaGurrLak
  G0YwoMlFO4YMSZjd9DcWucsjUr1Yqgy8TluCY3N9Q8.+k0JCD3ZTS0CW8Qyb
  s19nOxrgjw7VFU+3ooYviK66pCfimt8AAxHOOBkK+EajC2yayWtciMzgdvpM
  NKORj29YyGcS4wFVlql0wcZTg1yw5wvMNiTpuUzpu.Y0miRlgO0w7wpZI2Em
  SUBGayVM5eqU4C+rV4ZSPkvXqLJbAHlR3mKwT5ISL8+Kv0k.GWEKwpP3ewk3
  7omKIN7EtDmp4ZtHk0BfatXgLhgasHgZrVYaY8AIO7fq8Pas1fFzjd4ibwpd
  XO4GXOeOG+lcyasNh1R+wVx2yBxeTOT+wiZFYA0P48PNyiiVjAhJlNT4Qvpb
  uj3aN2qYqJcBfSWhMbf+YCPcsfbNeTC2l9WNc+5eIlkST0RJgupzIn+kysgC
  X6GGXnYpdYfP0GP6MKQXM3N1Ih6XVvcLuym7B0B5w8v.ahqBI49qJcJ.TaX.
  N+xBP4NGHhhqYfkRNM9q1f3ZweqyYCQYdGCSZGQ5wBx47o.Ssw+CkcgQOmud
  KZic4QKzCw+7ROm8nY2LfMsEDtdfeMKSn5Ev95IQhorcqJcBrzPsQUhRNe8M
  1X6lhOezC4Bidv1nKcFs8YimJ9n8RWZXiO7aSCxDRLdjd91qU5TnmXCeRvmR
  9jnm7b15RmJ9rO4Kr+IgO04BfczyOpqx9npzofOsIlaR8Mo0IUMR48i0mYly
  lVMwlw6gbloGRezy4yKEw6BHBBWik.eRi3DNM5KDahS.SOE1EjmXl7Uyqo9T
  AtQAO8fG3oLX3cZFxKh0FLNSRfDaoG74gdvW.ZDU9FMGSdFMBt+IQh.6eIvw
  FujTkJREGKKcJ3X2WtXf7Ub1HywEqxh2tJnE.FcZhMByrcXQw1x+bOWJYjpy
  lv8oq55aEHLcwD8hJjxbVU5EigcNtL7Ql76KVVp69Huhcb87vpoCkRYT+96v
  Hd5Ay1rofMqm+FkLYvv0+GL3FkL6bLp21kL6QFNV8BNM48foWBV4zt1wXm5V
  4jkNEbL45dtNw13Iltmi9sAyY0S0l8BR+3yWjVXax7eOmKrp4m0QKIal6VYo
  SAf5XQxSrCa5l0qk45k5kAzqEgMNgzkz9FmL5abpnu4IhNzZ+0s+OKCSg0.
  -----------end_max5_patcher-----------

*/

]]


examples.ArduinoISP = [[

// ArduinoISP
// Copyright (c) 2008-2011 Randall Bohn
// If you require a license, see
// https://opensource.org/licenses/bsd-license.php
//
// Note that this sketch refers to the SPI bus pins using the legacy MISO/MOSI
// names rather than the modern CIPO/COPI names.
// For further details, see https://docs.arduino.cc/learn/communication/spi
//
// This sketch turns the Arduino into a AVRISP using the following Arduino pins:
//
// Pin 10 is used to reset the target microcontroller.
//
// By default, the hardware SPI pins MISO, MOSI and SCK are used to communicate
// with the target. On all Arduinos, these pins can be found
// on the ICSP/SPI header:
//
//               MISO °. . 5V (!) Avoid this pin on Due, Zero...
//               SCK   . . MOSI
//                     . . GND
//
// On some Arduinos (Uno,...), pins MOSI, MISO and SCK are the same pins as
// digital pin 11, 12 and 13, respectively. That is why many tutorials instruct
// you to hook up the target to these pins. If you find this wiring more
// practical, have a define USE_OLD_STYLE_WIRING. This will work even when not
// using an Uno. (On an Uno this is not needed).
//
// Alternatively you can use any other digital pin by configuring
// software ('BitBanged') SPI and having appropriate defines for ARDUINOISP_PIN_MOSI,
// ARDUINOISP_PIN_MISO and ARDUINOISP_PIN_SCK.
//
// IMPORTANT: When using an Arduino that is not 5V tolerant (Due, Zero, ...) as
// the programmer, make sure to not expose any of the programmer's pins to 5V.
// A simple way to accomplish this is to power the complete system (programmer
// and target) at 3V3.
//
// Put an LED (with resistor) on the following pins:
// 9: Heartbeat   - shows the programmer is running
// 8: Error       - Lights up if something goes wrong (use red if that makes sense)
// 7: Programming - In communication with the target
//

#include "Arduino.h"
#undef SERIAL


#define PROG_FLICKER true

// Configure SPI clock (in Hz).
// E.g. for an ATtiny @ 128 kHz: the datasheet states that both the high and low
// SPI clock pulse must be > 2 CPU cycles, so take 3 cycles i.e. divide target
// f_cpu by 6:
//     #define SPI_CLOCK            (128000/6)
//
// A clock slow enough for an ATtiny85 @ 1 MHz, is a reasonable default:

#define SPI_CLOCK (1000000 / 6)


// Select hardware or software SPI, depending on SPI clock.
// Currently only for AVR, for other architectures (Due, Zero,...), hardware SPI
// is probably too fast anyway.

#if defined(ARDUINO_ARCH_AVR)

#if SPI_CLOCK > (F_CPU / 128)
#define USE_HARDWARE_SPI
#endif

#endif

// Configure which pins to use:

// The standard pin configuration.
#ifndef ARDUINO_HOODLOADER2

#define RESET 10  // Use pin 10 to reset the target rather than SS
#define LED_HB 9
#define LED_ERR 8
#define LED_PMODE 7

// Uncomment following line to use the old Uno style wiring
// (using pin 11, 12 and 13 instead of the SPI header) on Leonardo, Due...

// #define USE_OLD_STYLE_WIRING

#ifdef USE_OLD_STYLE_WIRING

#define ARDUINOISP_PIN_MOSI 11
#define ARDUINOISP_PIN_MISO 12
#define ARDUINOISP_PIN_SCK 13

#endif

// HOODLOADER2 means running sketches on the ATmega16U2 serial converter chips
// on Uno or Mega boards. We must use pins that are broken out:
#else

#define RESET 4
#define LED_HB 7
#define LED_ERR 6
#define LED_PMODE 5

#endif

// By default, use hardware SPI pins:
#ifndef ARDUINOISP_PIN_MOSI
#define ARDUINOISP_PIN_MOSI MOSI
#endif

#ifndef ARDUINOISP_PIN_MISO
#define ARDUINOISP_PIN_MISO MISO
#endif

#ifndef ARDUINOISP_PIN_SCK
#define ARDUINOISP_PIN_SCK SCK
#endif

// Force bitbanged SPI if not using the hardware SPI pins:
#if (ARDUINOISP_PIN_MISO != MISO) || (ARDUINOISP_PIN_MOSI != MOSI) || (ARDUINOISP_PIN_SCK != SCK)
#undef USE_HARDWARE_SPI
#endif


// Configure the serial port to use.
//
// Prefer the USB virtual serial port (aka. native USB port), if the Arduino has one:
//   - it does not autoreset (except for the magic baud rate of 1200).
//   - it is more reliable because of USB handshaking.
//
// Leonardo and similar have an USB virtual serial port: 'Serial'.
// Due and Zero have an USB virtual serial port: 'SerialUSB'.
//
// On the Due and Zero, 'Serial' can be used too, provided you disable autoreset.
// To use 'Serial': #define SERIAL Serial

#ifdef SERIAL_PORT_USBVIRTUAL
#define SERIAL SERIAL_PORT_USBVIRTUAL
#else
#define SERIAL Serial
#endif


// Configure the baud rate:

#define BAUDRATE 19200
// #define BAUDRATE	115200
// #define BAUDRATE	1000000


#define HWVER 2
#define SWMAJ 1
#define SWMIN 18

// STK Definitions
#define STK_OK 0x10
#define STK_FAILED 0x11
#define STK_UNKNOWN 0x12
#define STK_INSYNC 0x14
#define STK_NOSYNC 0x15
#define CRC_EOP 0x20  //ok it is a space...

void pulse(int pin, int times);

#ifdef USE_HARDWARE_SPI
#include "SPI.h"
#else

#define SPI_MODE0 0x00

#if !defined(ARDUINO_API_VERSION) || ARDUINO_API_VERSION != 10001  // A SPISettings class is declared by ArduinoCore-API 1.0.1
class SPISettings {
public:
  // clock is in Hz
  SPISettings(uint32_t clock, uint8_t bitOrder, uint8_t dataMode)
    : clockFreq(clock) {
    (void)bitOrder;
    (void)dataMode;
  };

  uint32_t getClockFreq() const {
    return clockFreq;
  }

private:
  uint32_t clockFreq;
};
#endif                                                             // !defined(ARDUINO_API_VERSION)

class BitBangedSPI {
public:
  void begin() {
    digitalWrite(ARDUINOISP_PIN_SCK, LOW);
    digitalWrite(ARDUINOISP_PIN_MOSI, LOW);
    pinMode(ARDUINOISP_PIN_SCK, OUTPUT);
    pinMode(ARDUINOISP_PIN_MOSI, OUTPUT);
    pinMode(ARDUINOISP_PIN_MISO, INPUT);
  }

  void beginTransaction(SPISettings settings) {
    pulseWidth = (500000 + settings.getClockFreq() - 1) / settings.getClockFreq();
    if (pulseWidth == 0) {
      pulseWidth = 1;
    }
  }

  void end() {}

  uint8_t transfer(uint8_t b) {
    for (unsigned int i = 0; i < 8; ++i) {
      digitalWrite(ARDUINOISP_PIN_MOSI, (b & 0x80) ? HIGH : LOW);
      digitalWrite(ARDUINOISP_PIN_SCK, HIGH);
      delayMicroseconds(pulseWidth);
      b = (b << 1) | digitalRead(ARDUINOISP_PIN_MISO);
      digitalWrite(ARDUINOISP_PIN_SCK, LOW);  // slow pulse
      delayMicroseconds(pulseWidth);
    }
    return b;
  }

private:
  unsigned long pulseWidth;  // in microseconds
};

static BitBangedSPI SPI;

#endif

void setup() {
  SERIAL.begin(BAUDRATE);

  pinMode(LED_PMODE, OUTPUT);
  pulse(LED_PMODE, 2);
  pinMode(LED_ERR, OUTPUT);
  pulse(LED_ERR, 2);
  pinMode(LED_HB, OUTPUT);
  pulse(LED_HB, 2);
}

int ISPError = 0;
int pmode = 0;
// address for reading and writing, set by 'U' command
unsigned int here;
uint8_t buff[256];  // global block storage

#define beget16(addr) (*addr * 256 + *(addr + 1))
typedef struct param {
  uint8_t devicecode;
  uint8_t revision;
  uint8_t progtype;
  uint8_t parmode;
  uint8_t polling;
  uint8_t selftimed;
  uint8_t lockbytes;
  uint8_t fusebytes;
  uint8_t flashpoll;
  uint16_t eeprompoll;
  uint16_t pagesize;
  uint16_t eepromsize;
  uint32_t flashsize;
} parameter;

parameter param;

// this provides a heartbeat on pin 9, so you can tell the software is running.
uint8_t hbval = 128;
int8_t hbdelta = 8;
void heartbeat() {
  static unsigned long last_time = 0;
  unsigned long now = millis();
  if ((now - last_time) < 40) {
    return;
  }
  last_time = now;
  if (hbval > 192) {
    hbdelta = -hbdelta;
  }
  if (hbval < 32) {
    hbdelta = -hbdelta;
  }
  hbval += hbdelta;
  analogWrite(LED_HB, hbval);
}

static bool rst_active_high;

void reset_target(bool reset) {
  digitalWrite(RESET, ((reset && rst_active_high) || (!reset && !rst_active_high)) ? HIGH : LOW);
}

void loop(void) {
  // is pmode active?
  if (pmode) {
    digitalWrite(LED_PMODE, HIGH);
  } else {
    digitalWrite(LED_PMODE, LOW);
  }
  // is there an error?
  if (ISPError) {
    digitalWrite(LED_ERR, HIGH);
  } else {
    digitalWrite(LED_ERR, LOW);
  }

  // light the heartbeat LED
  heartbeat();
  if (SERIAL.available()) {
    avrisp();
  }
}

uint8_t getch() {
  while (!SERIAL.available())
    ;
  return SERIAL.read();
}
void fill(int n) {
  for (int x = 0; x < n; x++) {
    buff[x] = getch();
  }
}

#define PTIME 30
void pulse(int pin, int times) {
  do {
    digitalWrite(pin, HIGH);
    delay(PTIME);
    digitalWrite(pin, LOW);
    delay(PTIME);
  } while (times--);
}

void prog_lamp(int state) {
  if (PROG_FLICKER) {
    digitalWrite(LED_PMODE, state);
  }
}

uint8_t spi_transaction(uint8_t a, uint8_t b, uint8_t c, uint8_t d) {
  SPI.transfer(a);
  SPI.transfer(b);
  SPI.transfer(c);
  return SPI.transfer(d);
}

void empty_reply() {
  if (CRC_EOP == getch()) {
    SERIAL.print((char)STK_INSYNC);
    SERIAL.print((char)STK_OK);
  } else {
    ISPError++;
    SERIAL.print((char)STK_NOSYNC);
  }
}

void breply(uint8_t b) {
  if (CRC_EOP == getch()) {
    SERIAL.print((char)STK_INSYNC);
    SERIAL.print((char)b);
    SERIAL.print((char)STK_OK);
  } else {
    ISPError++;
    SERIAL.print((char)STK_NOSYNC);
  }
}

void get_version(uint8_t c) {
  switch (c) {
    case 0x80:
      breply(HWVER);
      break;
    case 0x81:
      breply(SWMAJ);
      break;
    case 0x82:
      breply(SWMIN);
      break;
    case 0x93:
      breply('S');  // serial programmer
      break;
    default:
      breply(0);
  }
}

void set_parameters() {
  // call this after reading parameter packet into buff[]
  param.devicecode = buff[0];
  param.revision = buff[1];
  param.progtype = buff[2];
  param.parmode = buff[3];
  param.polling = buff[4];
  param.selftimed = buff[5];
  param.lockbytes = buff[6];
  param.fusebytes = buff[7];
  param.flashpoll = buff[8];
  // ignore buff[9] (= buff[8])
  // following are 16 bits (big endian)
  param.eeprompoll = beget16(&buff[10]);
  param.pagesize = beget16(&buff[12]);
  param.eepromsize = beget16(&buff[14]);

  // 32 bits flashsize (big endian)
  param.flashsize = buff[16] * 0x01000000
                    + buff[17] * 0x00010000
                    + buff[18] * 0x00000100
                    + buff[19];

  // AVR devices have active low reset, AT89Sx are active high
  rst_active_high = (param.devicecode >= 0xe0);
}

void start_pmode() {

  // Reset target before driving ARDUINOISP_PIN_SCK or ARDUINOISP_PIN_MOSI

  // SPI.begin() will configure SS as output, so SPI master mode is selected.
  // We have defined RESET as pin 10, which for many Arduinos is not the SS pin.
  // So we have to configure RESET as output here,
  // (reset_target() first sets the correct level)
  reset_target(true);
  pinMode(RESET, OUTPUT);
  SPI.begin();
  SPI.beginTransaction(SPISettings(SPI_CLOCK, MSBFIRST, SPI_MODE0));

  // See AVR datasheets, chapter "SERIAL_PRG Programming Algorithm":

  // Pulse RESET after ARDUINOISP_PIN_SCK is low:
  digitalWrite(ARDUINOISP_PIN_SCK, LOW);
  delay(20);  // discharge ARDUINOISP_PIN_SCK, value arbitrarily chosen
  reset_target(false);
  // Pulse must be minimum 2 target CPU clock cycles so 100 usec is ok for CPU
  // speeds above 20 KHz
  delayMicroseconds(100);
  reset_target(true);

  // Send the enable programming command:
  delay(50);  // datasheet: must be > 20 msec
  spi_transaction(0xAC, 0x53, 0x00, 0x00);
  pmode = 1;
}

void end_pmode() {
  SPI.end();
  // We're about to take the target out of reset so configure SPI pins as input
  pinMode(ARDUINOISP_PIN_MOSI, INPUT);
  pinMode(ARDUINOISP_PIN_SCK, INPUT);
  reset_target(false);
  pinMode(RESET, INPUT);
  pmode = 0;
}

void universal() {
  uint8_t ch;

  fill(4);
  ch = spi_transaction(buff[0], buff[1], buff[2], buff[3]);
  breply(ch);
}

void flash(uint8_t hilo, unsigned int addr, uint8_t data) {
  spi_transaction(0x40 + 8 * hilo,
                  addr >> 8 & 0xFF,
                  addr & 0xFF,
                  data);
}
void commit(unsigned int addr) {
  if (PROG_FLICKER) {
    prog_lamp(LOW);
  }
  spi_transaction(0x4C, (addr >> 8) & 0xFF, addr & 0xFF, 0);
  if (PROG_FLICKER) {
    delay(PTIME);
    prog_lamp(HIGH);
  }
}

unsigned int current_page() {
  if (param.pagesize == 32) {
    return here & 0xFFFFFFF0;
  }
  if (param.pagesize == 64) {
    return here & 0xFFFFFFE0;
  }
  if (param.pagesize == 128) {
    return here & 0xFFFFFFC0;
  }
  if (param.pagesize == 256) {
    return here & 0xFFFFFF80;
  }
  return here;
}


void write_flash(int length) {
  fill(length);
  if (CRC_EOP == getch()) {
    SERIAL.print((char)STK_INSYNC);
    SERIAL.print((char)write_flash_pages(length));
  } else {
    ISPError++;
    SERIAL.print((char)STK_NOSYNC);
  }
}

uint8_t write_flash_pages(int length) {
  int x = 0;
  unsigned int page = current_page();
  while (x < length) {
    if (page != current_page()) {
      commit(page);
      page = current_page();
    }
    flash(LOW, here, buff[x++]);
    flash(HIGH, here, buff[x++]);
    here++;
  }

  commit(page);

  return STK_OK;
}

#define EECHUNK (32)
uint8_t write_eeprom(unsigned int length) {
  // here is a word address, get the byte address
  unsigned int start = here * 2;
  unsigned int remaining = length;
  if (length > param.eepromsize) {
    ISPError++;
    return STK_FAILED;
  }
  while (remaining > EECHUNK) {
    write_eeprom_chunk(start, EECHUNK);
    start += EECHUNK;
    remaining -= EECHUNK;
  }
  write_eeprom_chunk(start, remaining);
  return STK_OK;
}
// write (length) bytes, (start) is a byte address
uint8_t write_eeprom_chunk(unsigned int start, unsigned int length) {
  // this writes byte-by-byte, page writing may be faster (4 bytes at a time)
  fill(length);
  prog_lamp(LOW);
  for (unsigned int x = 0; x < length; x++) {
    unsigned int addr = start + x;
    spi_transaction(0xC0, (addr >> 8) & 0xFF, addr & 0xFF, buff[x]);
    delay(45);
  }
  prog_lamp(HIGH);
  return STK_OK;
}

void program_page() {
  char result = (char)STK_FAILED;
  unsigned int length = 256 * getch();
  length += getch();
  char memtype = getch();
  // flash memory @here, (length) bytes
  if (memtype == 'F') {
    write_flash(length);
    return;
  }
  if (memtype == 'E') {
    result = (char)write_eeprom(length);
    if (CRC_EOP == getch()) {
      SERIAL.print((char)STK_INSYNC);
      SERIAL.print(result);
    } else {
      ISPError++;
      SERIAL.print((char)STK_NOSYNC);
    }
    return;
  }
  SERIAL.print((char)STK_FAILED);
  return;
}

uint8_t flash_read(uint8_t hilo, unsigned int addr) {
  return spi_transaction(0x20 + hilo * 8,
                         (addr >> 8) & 0xFF,
                         addr & 0xFF,
                         0);
}

char flash_read_page(int length) {
  for (int x = 0; x < length; x += 2) {
    uint8_t low = flash_read(LOW, here);
    SERIAL.print((char)low);
    uint8_t high = flash_read(HIGH, here);
    SERIAL.print((char)high);
    here++;
  }
  return STK_OK;
}

char eeprom_read_page(int length) {
  // here again we have a word address
  int start = here * 2;
  for (int x = 0; x < length; x++) {
    int addr = start + x;
    uint8_t ee = spi_transaction(0xA0, (addr >> 8) & 0xFF, addr & 0xFF, 0xFF);
    SERIAL.print((char)ee);
  }
  return STK_OK;
}

void read_page() {
  char result = (char)STK_FAILED;
  int length = 256 * getch();
  length += getch();
  char memtype = getch();
  if (CRC_EOP != getch()) {
    ISPError++;
    SERIAL.print((char)STK_NOSYNC);
    return;
  }
  SERIAL.print((char)STK_INSYNC);
  if (memtype == 'F') {
    result = flash_read_page(length);
  }
  if (memtype == 'E') {
    result = eeprom_read_page(length);
  }
  SERIAL.print(result);
}

void read_signature() {
  if (CRC_EOP != getch()) {
    ISPError++;
    SERIAL.print((char)STK_NOSYNC);
    return;
  }
  SERIAL.print((char)STK_INSYNC);
  uint8_t high = spi_transaction(0x30, 0x00, 0x00, 0x00);
  SERIAL.print((char)high);
  uint8_t middle = spi_transaction(0x30, 0x00, 0x01, 0x00);
  SERIAL.print((char)middle);
  uint8_t low = spi_transaction(0x30, 0x00, 0x02, 0x00);
  SERIAL.print((char)low);
  SERIAL.print((char)STK_OK);
}
//////////////////////////////////////////
//////////////////////////////////////////


////////////////////////////////////
////////////////////////////////////
void avrisp() {
  uint8_t ch = getch();
  switch (ch) {
    case '0':  // signon
      ISPError = 0;
      empty_reply();
      break;
    case '1':
      if (getch() == CRC_EOP) {
        SERIAL.print((char)STK_INSYNC);
        SERIAL.print("AVR ISP");
        SERIAL.print((char)STK_OK);
      } else {
        ISPError++;
        SERIAL.print((char)STK_NOSYNC);
      }
      break;
    case 'A':
      get_version(getch());
      break;
    case 'B':
      fill(20);
      set_parameters();
      empty_reply();
      break;
    case 'E':  // extended parameters - ignore for now
      fill(5);
      empty_reply();
      break;
    case 'P':
      if (!pmode) {
        start_pmode();
      }
      empty_reply();
      break;
    case 'U':  // set address (word)
      here = getch();
      here += 256 * getch();
      empty_reply();
      break;

    case 0x60:  //STK_PROG_FLASH
      getch();  // low addr
      getch();  // high addr
      empty_reply();
      break;
    case 0x61:  //STK_PROG_DATA
      getch();  // data
      empty_reply();
      break;

    case 0x64:  //STK_PROG_PAGE
      program_page();
      break;

    case 0x74:  //STK_READ_PAGE 't'
      read_page();
      break;

    case 'V':  //0x56
      universal();
      break;
    case 'Q':  //0x51
      ISPError = 0;
      end_pmode();
      empty_reply();
      break;

    case 0x75:  //STK_READ_SIGN 'u'
      read_signature();
      break;

    // expecting a command, not CRC_EOP
    // this is how we can get back in sync
    case CRC_EOP:
      ISPError++;
      SERIAL.print((char)STK_NOSYNC);
      break;

    // anything else we will return STK_UNKNOWN
    default:
      ISPError++;
      if (CRC_EOP == getch()) {
        SERIAL.print((char)STK_UNKNOWN);
      } else {
        SERIAL.print((char)STK_NOSYNC);
      }
  }
}

]]


examples.AnalogInOutSerial = [[

/*
  Analog input, analog output, serial output

  Reads an analog input pin, maps the result to a range from 0 to 255 and uses
  the result to set the pulse width modulation (PWM) of an output pin.
  Also prints the results to the Serial Monitor.

  The circuit:
  - potentiometer connected to analog pin 0.
    Center pin of the potentiometer goes to the analog pin.
    side pins of the potentiometer go to +5V and ground
  - LED connected from digital pin 9 to ground through 220 ohm resistor

  created 29 Dec. 2008
  modified 9 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/analog/AnalogInOutSerial/
*/

// These constants won't change. They're used to give names to the pins used:
const int analogInPin = A0;  // Analog input pin that the potentiometer is attached to
const int analogOutPin = 9;  // Analog output pin that the LED is attached to

int sensorValue = 0;  // value read from the pot
int outputValue = 0;  // value output to the PWM (analog out)

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
}

void loop() {
  // read the analog in value:
  sensorValue = analogRead(analogInPin);
  // map it to the range of the analog out:
  outputValue = map(sensorValue, 0, 1023, 0, 255);
  // change the analog out value:
  analogWrite(analogOutPin, outputValue);

  // print the results to the Serial Monitor:
  Serial.print("sensor = ");
  Serial.print(sensorValue);
  Serial.print("\t output = ");
  Serial.println(outputValue);

  // wait 2 milliseconds before the next loop for the analog-to-digital
  // converter to settle after the last reading:
  delay(2);
}

]]


examples.KeyboardMessage = [[

/*
  Keyboard Message test

  For the Arduino Leonardo and Micro.

  Sends a text string when a button is pressed.

  The circuit:
  - pushbutton attached from pin 4 to +5V
  - 10 kilohm resistor attached from pin 4 to ground

  created 24 Oct 2011
  modified 27 Mar 2012
  by Tom Igoe
  modified 11 Nov 2013
  by Scott Fitzgerald

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/usb/KeyboardMessage/
*/

#include "Keyboard.h"

const int buttonPin = 4;         // input pin for pushbutton
int previousButtonState = HIGH;  // for checking the state of a pushButton
int counter = 0;                 // button push counter

void setup() {
  // make the pushButton pin an input:
  pinMode(buttonPin, INPUT);
  // initialize control over the keyboard:
  Keyboard.begin();
}

void loop() {
  // read the pushbutton:
  int buttonState = digitalRead(buttonPin);
  // if the button state has changed,
  if ((buttonState != previousButtonState)
      // and it's currently pressed:
      && (buttonState == HIGH)) {
    // increment the button counter
    counter++;
    // type out a message
    Keyboard.print("You pressed the button ");
    Keyboard.print(counter);
    Keyboard.println(" times.");
  }
  // save the current button state for comparison next time:
  previousButtonState = buttonState;
}

]]


examples.Dimmer = [[

/*
  Dimmer

  Demonstrates sending data from the computer to the Arduino board, in this case
  to control the brightness of an LED. The data is sent in individual bytes,
  each of which ranges from 0 to 255. Arduino reads these bytes and uses them to
  set the brightness of the LED.

  The circuit:
  - LED attached from digital pin 9 to ground through 220 ohm resistor.
  - Serial connection to Processing, Max/MSP, or another serial application

  created 2006
  by David A. Mellis
  modified 30 Aug 2011
  by Tom Igoe and Scott Fitzgerald

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/communication/Dimmer/
*/

const int ledPin = 9;  // the pin that the LED is attached to

void setup() {
  // initialize the serial communication:
  Serial.begin(9600);
  // initialize the ledPin as an output:
  pinMode(ledPin, OUTPUT);
}

void loop() {
  byte brightness;

  // check if data has been sent from the computer:
  if (Serial.available()) {
    // read the most recent byte (which will be from 0 to 255):
    brightness = Serial.read();
    // set the brightness of the LED:
    analogWrite(ledPin, brightness);
  }
}

/* Processing code for this example

  // Dimmer - sends bytes over a serial port

  // by David A. Mellis
  // This example code is in the public domain.

  import processing.serial.*;
  Serial port;

  void setup() {
    size(256, 150);

    println("Available serial ports:");
    // if using Processing 2.1 or later, use Serial.printArray()
    println(Serial.list());

    // Uses the first port in this list (number 0). Change this to select the port
    // corresponding to your Arduino board. The last parameter (e.g. 9600) is the
    // speed of the communication. It has to correspond to the value passed to
    // Serial.begin() in your Arduino sketch.
    port = new Serial(this, Serial.list()[0], 9600);

    // If you know the name of the port used by the Arduino board, you can specify
    // it directly like this.
    //port = new Serial(this, "COM1", 9600);
  }

  void draw() {
    // draw a gradient from black to white
    for (int i = 0; i < 256; i++) {
      stroke(i);
      line(i, 0, i, 150);
    }

    // write the current X-position of the mouse to the serial port as
    // a single byte
    port.write(mouseX);
  }

*/

/* Max/MSP v5 patch for this example

  ----------begin_max5_patcher----------
  1008.3ocuXszaiaCD9r8uhA5rqAeHIa0aAMaAVf1S6hdoYQAsDiL6JQZHQ2M
  YWr+2KeX4vjnjXKKkKhhiGQ9MeyCNz+X9rnMp63sQvuB+MLa1OlOalSjUvrC
  ymEUytKuh05TKJWUWyk5nE9eSyuS6jesvHu4F4MxOuUzB6X57sPKWVzBLXiP
  xZtGj6q2vafaaT0.BzJfjj.p8ZPukazsQvpfcpFs8mXR3plh8BoBxURIOWyK
  rxspZ0YI.eTCEh5Vqp+wGtFXZMKe6CZc3yWZwTdCmYW.BBkdiby8v0r+ST.W
  sD9SdUkn8FYspPbqvnBNFtZWiUyLmleJWo0vuKzeuj2vpJLaWA7YiE7wREui
  FpDFDp1KcbAFcP5sJoVxp4NB5Jq40ougIDxJt1wo3GDZHiNocKhiIExx+owv
  AdOEAksDs.RRrOoww1Arc.9RvN2J9tamwjkcqknvAE0l+8WnjHqreNet8whK
  z6mukIK4d+Xknv3jstvJs8EirMMhxsZIusET25jXbX8xczIl5xPVxhPcTGFu
  xNDu9rXtUCg37g9Q8Yc+EuofIYmg8QdkPCrOnXsaHwYs3rWx9PGsO+pqueG2
  uNQBqWFh1X7qQG+3.VHcHrfO1nyR2TlqpTM9MDsLKNCQVz6KO.+Sfc5j1Ykj
  jzkn2jwNDRP7LVb3d9LtoWBAOnvB92Le6yRmZ4UF7YpQhiFi7A5Ka8zXhKdA
  4r9TRGG7V4COiSbAJKdXrWNhhF0hNUh7uBa4Mba0l7JUK+omjDMwkSn95Izr
  TOwkdp7W.oPRmNRQsiKeu4j3CkfVgt.NYPEYqMGvvJ48vIlPiyzrIuZskWIS
  xGJPcmPiWOfLodybH3wjPbMYwlbFIMNHPHFOtLBNaLSa9sGk1TxMzCX5KTa6
  WIH2ocxSdngM0QPqFRxyPHFsprrhGc9Gy9xoBjz0NWdR2yW9DUa2F85jG2v9
  FgTO4Q8qiC7fzzQNpmNpsY3BrYPVJBMJQ1uVmoItRhw9NrVGO3NMNzYZ+zS7
  3WTvTOnUydG5kHMKLqAOjTe7fN2bGSxOZDkMrBrGQ9J1gONBEy0k4gVo8qHc
  cxmfxVihWz6a3yqY9NazzUYkua9UnynadOtogW.JfsVGRVNEbWF8I+eHtcwJ
  +wLXqZeSdWLo+FQF6731Tva0BISKTx.cLwmgJsUTTvkg1YsnXmxDge.CDR7x
  D6YmX6fMznaF7kdczmJXwm.XSOOrdoHhNA7GMiZYLZZR.+4lconMaJP6JOZ8
  ftCs1YWHZI3o.sIXezX5ihMSuXzZtk3ai1mXRSczoCS32hAydeyXNEu5SHyS
  xqZqbd3ZLdera1iPqYxOm++v7SUSz
  -----------end_max5_patcher-----------

*/

]]


examples.Fading = [[

/*
  Fading

  This example shows how to fade an LED using the analogWrite() function.

  The circuit:
  - LED attached from digital pin 9 to ground through 220 ohm resistor.

  created 1 Nov 2008
  by David A. Mellis
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/analog/Fading/
*/

int ledPin = 9;  // LED connected to digital pin 9

void setup() {
  // nothing happens in setup
}

void loop() {
  // fade in from min to max in increments of 5 points:
  for (int fadeValue = 0; fadeValue <= 255; fadeValue += 5) {
    // sets the value (range from 0 to 255):
    analogWrite(ledPin, fadeValue);
    // wait for 30 milliseconds to see the dimming effect
    delay(30);
  }

  // fade out from max to min in increments of 5 points:
  for (int fadeValue = 255; fadeValue >= 0; fadeValue -= 5) {
    // sets the value (range from 0 to 255):
    analogWrite(ledPin, fadeValue);
    // wait for 30 milliseconds to see the dimming effect
    delay(30);
  }
}

]]


examples.p04_ColorMixingLamp = [[

/*
  Arduino Starter Kit example
  Project 4 - Color Mixing Lamp

  This sketch is written to accompany Project 3 in the Arduino Starter Kit

  Parts required:
  - one RGB LED
  - three 10 kilohm resistors
  - three 220 ohm resistors
  - three photoresistors
  - red green and blue colored gels

  created 13 Sep 2012
  modified 14 Nov 2012
  by Scott Fitzgerald
  Thanks to Federico Vanzati for improvements

  https://store.arduino.cc/genuino-starter-kit

  This example code is part of the public domain.
*/

const int greenLEDPin = 9;  // LED connected to digital pin 9
const int redLEDPin = 10;   // LED connected to digital pin 10
const int blueLEDPin = 11;  // LED connected to digital pin 11

const int redSensorPin = A0;    // pin with the photoresistor with the red gel
const int greenSensorPin = A1;  // pin with the photoresistor with the green gel
const int blueSensorPin = A2;   // pin with the photoresistor with the blue gel

int redValue = 0;    // value to write to the red LED
int greenValue = 0;  // value to write to the green LED
int blueValue = 0;   // value to write to the blue LED

int redSensorValue = 0;    // variable to hold the value from the red sensor
int greenSensorValue = 0;  // variable to hold the value from the green sensor
int blueSensorValue = 0;   // variable to hold the value from the blue sensor

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);

  // set the digital pins as outputs
  pinMode(greenLEDPin, OUTPUT);
  pinMode(redLEDPin, OUTPUT);
  pinMode(blueLEDPin, OUTPUT);
}

void loop() {
  // Read the sensors first:

  // read the value from the red-filtered photoresistor:
  redSensorValue = analogRead(redSensorPin);
  // give the ADC a moment to settle
  delay(5);
  // read the value from the green-filtered photoresistor:
  greenSensorValue = analogRead(greenSensorPin);
  // give the ADC a moment to settle
  delay(5);
  // read the value from the blue-filtered photoresistor:
  blueSensorValue = analogRead(blueSensorPin);

  // print out the values to the Serial Monitor
  Serial.print("raw sensor Values \t red: ");
  Serial.print(redSensorValue);
  Serial.print("\t green: ");
  Serial.print(greenSensorValue);
  Serial.print("\t Blue: ");
  Serial.println(blueSensorValue);

  /*
    In order to use the values from the sensor for the LED, you need to do some
    math. The ADC provides a 10-bit number, but analogWrite() uses 8 bits.
    You'll want to divide your sensor readings by 4 to keep them in range
    of the output.
  */
  redValue = redSensorValue / 4;
  greenValue = greenSensorValue / 4;
  blueValue = blueSensorValue / 4;

  // print out the mapped values
  Serial.print("Mapped sensor Values \t red: ");
  Serial.print(redValue);
  Serial.print("\t green: ");
  Serial.print(greenValue);
  Serial.print("\t Blue: ");
  Serial.println(blueValue);

  /*
    Now that you have a usable value, it's time to PWM the LED.
  */
  analogWrite(redLEDPin, redValue);
  analogWrite(greenLEDPin, greenValue);
  analogWrite(blueLEDPin, blueValue);
}

]]


examples.StringLength = [[

/*
  String length()

  Examples of how to use length() in a String.
  Open the Serial Monitor and start sending characters to see the results.

  created 1 Aug 2010
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringLengthTrim/
*/

String txtMsg = "";                               // a string for incoming text
unsigned int lastStringLength = txtMsg.length();  // previous length of the String

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  // send an intro:
  Serial.println("\n\nString  length():");
  Serial.println();
}

void loop() {
  // add any incoming characters to the String:
  while (Serial.available() > 0) {
    char inChar = Serial.read();
    txtMsg += inChar;
  }

  // print the message and a notice if it's changed:
  if (txtMsg.length() != lastStringLength) {
    Serial.println(txtMsg);
    Serial.println(txtMsg.length());
    // if the String's longer than 140 characters, complain:
    if (txtMsg.length() < 140) {
      Serial.println("That's a perfectly acceptable text message");
    } else {
      Serial.println("That's too long for a text message.");
    }
    // note the length for next time through the loop:
    lastStringLength = txtMsg.length();
  }
}

]]


examples.KeyboardAndMouseControl = [[

/*
  KeyboardAndMouseControl

  Controls the mouse from five pushbuttons on an Arduino Leonardo, Micro or Due.

  Hardware:
  - five pushbuttons attached to D2, D3, D4, D5, D6

  The mouse movement is always relative. This sketch reads four pushbuttons, and
  uses them to set the movement of the mouse.

  WARNING: When you use the Mouse.move() command, the Arduino takes over your
  mouse! Make sure you have control before you use the mouse commands.

  created 15 Mar 2012
  modified 27 Mar 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/usb/KeyboardAndMouseControl/
*/

#include "Keyboard.h"
#include "Mouse.h"

// set pin numbers for the five buttons:
const int upButton = 2;
const int downButton = 3;
const int leftButton = 4;
const int rightButton = 5;
const int mouseButton = 6;

void setup() {  // initialize the buttons' inputs:
  pinMode(upButton, INPUT);
  pinMode(downButton, INPUT);
  pinMode(leftButton, INPUT);
  pinMode(rightButton, INPUT);
  pinMode(mouseButton, INPUT);

  Serial.begin(9600);
  // initialize mouse control:
  Mouse.begin();
  Keyboard.begin();
}

void loop() {
  // use serial input to control the mouse:
  if (Serial.available() > 0) {
    char inChar = Serial.read();

    switch (inChar) {
      case 'u':
        // move mouse up
        Mouse.move(0, -40);
        break;
      case 'd':
        // move mouse down
        Mouse.move(0, 40);
        break;
      case 'l':
        // move mouse left
        Mouse.move(-40, 0);
        break;
      case 'r':
        // move mouse right
        Mouse.move(40, 0);
        break;
      case 'm':
        // perform mouse left click
        Mouse.click(MOUSE_LEFT);
        break;
    }
  }

  // use the pushbuttons to control the keyboard:
  if (digitalRead(upButton) == HIGH) {
    Keyboard.write('u');
  }
  if (digitalRead(downButton) == HIGH) {
    Keyboard.write('d');
  }
  if (digitalRead(leftButton) == HIGH) {
    Keyboard.write('l');
  }
  if (digitalRead(rightButton) == HIGH) {
    Keyboard.write('r');
  }
  if (digitalRead(mouseButton) == HIGH) {
    Keyboard.write('m');
  }
}

]]


examples.KeyboardSerial = [[

/*
  Keyboard test

  For the Arduino Leonardo, Micro or Due

  Reads a byte from the serial port, sends a keystroke back.
  The sent keystroke is one higher than what's received, e.g. if you send a,
  you get b, send A you get B, and so forth.

  The circuit:
  - none

  created 21 Oct 2011
  modified 27 Mar 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/usb/KeyboardSerial/
*/

#include "Keyboard.h"

void setup() {
  // open the serial port:
  Serial.begin(9600);
  // initialize control over the keyboard:
  Keyboard.begin();
}

void loop() {
  // check for incoming serial data:
  if (Serial.available() > 0) {
    // read incoming serial data:
    char inChar = Serial.read();
    // Type the next ASCII value from what you received:
    Keyboard.write(inChar + 1);
  }
}

]]


examples.Button = [[

/*
  Button

  Turns on and off a light emitting diode(LED) connected to digital pin 13,
  when pressing a pushbutton attached to pin 2.

  The circuit:
  - LED attached from pin 13 to ground through 220 ohm resistor
  - pushbutton attached to pin 2 from +5V
  - 10K resistor attached to pin 2 from ground

  - Note: on most Arduinos there is already an LED on the board
    attached to pin 13.

  created 2005
  by DojoDave <http://www.0j0.org>
  modified 30 Aug 2011
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/digital/Button/
*/

// constants won't change. They're used here to set pin numbers:
const int buttonPin = 2;  // the number of the pushbutton pin
const int ledPin = 13;    // the number of the LED pin

// variables will change:
int buttonState = 0;  // variable for reading the pushbutton status

void setup() {
  // initialize the LED pin as an output:
  pinMode(ledPin, OUTPUT);
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);
}

void loop() {
  // read the state of the pushbutton value:
  buttonState = digitalRead(buttonPin);

  // check if the pushbutton is pressed. If it is, the buttonState is HIGH:
  if (buttonState == HIGH) {
    // turn LED on:
    digitalWrite(ledPin, HIGH);
  } else {
    // turn LED off:
    digitalWrite(ledPin, LOW);
  }
}

]]


examples.StringReplace = [[

/*
  String replace()

  Examples of how to replace characters or substrings of a String

  created 27 Jul 2010
  modified 2 Apr 2012
  by Tom Igoe

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/strings/StringReplace/
*/

void setup() {
  // Open serial communications and wait for port to open:
  Serial.begin(9600);
  while (!Serial) {
    ;  // wait for serial port to connect. Needed for native USB port only
  }

  // send an intro:
  Serial.println("\n\nString replace:\n");
  Serial.println();
}

void loop() {
  String stringOne = "<html><head><body>";
  Serial.println(stringOne);
  // replace() changes all instances of one substring with another:
  // first, make a copy of the original string:
  String stringTwo = stringOne;
  // then perform the replacements:
  stringTwo.replace("<", "</");
  // print the original:
  Serial.println("Original string: " + stringOne);
  // and print the modified string:
  Serial.println("Modified string: " + stringTwo);

  // you can also use replace() on single characters:
  String normalString = "bookkeeper";
  Serial.println("normal: " + normalString);
  String leetString = normalString;
  leetString.replace('o', '0');
  leetString.replace('e', '3');
  Serial.println("l33tspeak: " + leetString);

  // do nothing while true:
  while (true)
    ;
}

]]


examples.SerialPassthrough = [[

/*
  SerialPassthrough sketch

  Some boards, like the Arduino 101, the MKR1000, Zero, or the Micro, have one
  hardware serial port attached to Digital pins 0-1, and a separate USB serial
  port attached to the IDE Serial Monitor. This means that the "serial
  passthrough" which is possible with the Arduino UNO (commonly used to interact
  with devices/shields that require configuration via serial AT commands) will
  not work by default.

  This sketch allows you to emulate the serial passthrough behaviour. Any text
  you type in the IDE Serial monitor will be written out to the serial port on
  Digital pins 0 and 1, and vice-versa.

  On the 101, MKR1000, Zero, and Micro, "Serial" refers to the USB Serial port
  attached to the Serial Monitor, and "Serial1" refers to the hardware serial
  port attached to pins 0 and 1. This sketch will emulate Serial passthrough
  using those two Serial ports on the boards mentioned above, but you can change
  these names to connect any two serial ports on a board that has multiple ports.

  created 23 May 2016
  by Erik Nyquist

  https://docs.arduino.cc/built-in-examples/communication/SerialPassthrough/
*/

void setup() {
  Serial.begin(9600);
  Serial1.begin(9600);
}

void loop() {
  if (Serial.available()) {        // If anything comes in Serial (USB),
    Serial1.write(Serial.read());  // read it and send it out Serial1 (pins 0 & 1)
  }

  if (Serial1.available()) {       // If anything comes in Serial1 (pins 0 & 1)
    Serial.write(Serial1.read());  // read it and send it out Serial (USB)
  }
}

]]


examples.Calibration = [[

/*
  Calibration

  Demonstrates one technique for calibrating sensor input. The sensor readings
  during the first five seconds of the sketch execution define the minimum and
  maximum of expected values attached to the sensor pin.

  The sensor minimum and maximum initial values may seem backwards. Initially,
  you set the minimum high and listen for anything lower, saving it as the new
  minimum. Likewise, you set the maximum low and listen for anything higher as
  the new maximum.

  The circuit:
  - analog sensor (potentiometer will do) attached to analog input 0
  - LED attached from digital pin 9 to ground through 220 ohm resistor

  created 29 Oct 2008
  by David A Mellis
  modified 30 Aug 2011
  by Tom Igoe
  modified 07 Apr 2017
  by Zachary J. Fields

  This example code is in the public domain.

  https://docs.arduino.cc/built-in-examples/analog/Calibration/
*/

// These constants won't change:
const int sensorPin = A0;  // pin that the sensor is attached to
const int ledPin = 9;      // pin that the LED is attached to

// variables:
int sensorValue = 0;   // the sensor value
int sensorMin = 1023;  // minimum sensor value
int sensorMax = 0;     // maximum sensor value


void setup() {
  // turn on LED to signal the start of the calibration period:
  pinMode(13, OUTPUT);
  digitalWrite(13, HIGH);

  // calibrate during the first five seconds
  while (millis() < 5000) {
    sensorValue = analogRead(sensorPin);

    // record the maximum sensor value
    if (sensorValue > sensorMax) {
      sensorMax = sensorValue;
    }

    // record the minimum sensor value
    if (sensorValue < sensorMin) {
      sensorMin = sensorValue;
    }
  }

  // signal the end of the calibration period
  digitalWrite(13, LOW);
}

void loop() {
  // read the sensor:
  sensorValue = analogRead(sensorPin);

  // in case the sensor value is outside the range seen during calibration
  sensorValue = constrain(sensorValue, sensorMin, sensorMax);

  // apply the calibration to the sensor reading
  sensorValue = map(sensorValue, sensorMin, sensorMax, 0, 255);

  // fade the LED using the calibrated value:
  analogWrite(ledPin, sensorValue);
}

]]

return examples
