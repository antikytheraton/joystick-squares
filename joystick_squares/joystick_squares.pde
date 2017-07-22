import processing.serial.*;

Serial myPort;                       // The serial port
int[] serialInArray = new int[2];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive
int xpos, ypos;                      // Starting position of the ball
boolean firstContact = false;        // Whether we've heard from the microcontroller

int playArea = 500;
void setup() {
  size(500, 500);
  background(255);  //set background white
  frameRate(9001);  //get it

  // Set the starting position of the ball (middle of the stage)
  xpos = width/2;
  ypos = height/2;

  // Print a list of the serial ports for debugging purposes
  // if using Processing 2.1 or later, use Serial.printArray()
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');
}


void draw() {
  int rectSize= 25; //NOT the size of rectum (see var rectm)

  //all of this looks really messy because I did some
  for (int i=0; i<=playArea; i=i+rectSize) {                        //hard fixes instead of figuring out how to make
    for (int j=0; j<=playArea; j=j+rectSize) {                //everything fit together well
      //rectangle here
      float distance= dist(i+rectSize/2, j+rectSize/2, mouseX, mouseY);
      float rando=random(1, 50); //generates a random number
      float randomizer =((rando+5)/(rando+5+1)); //makes the random number really close to 1
      float size = (1000/(distance)+200)*randomizer;   //random
      float filler = -distance*distance/1000 +255;
      fill(filler*4/5, filler+10, filler+40);
      rect(i-size/2+100, j-size/2+100, rectSize, rectSize);
      //rect(i-sin(i),j-sin(j),rectSize,rectSize); not very interesting
    }
  }  //(100/(size+1))*
}


void serialEvent(Serial myPort) {
  // read the string from the serial port:
  String rawString = myPort.readString();
  println(rawString);
  //trim any unwanted empty spaces
  rawString = rawString.trim();
  try {
    //split the string into an array of 2 value (e.g. "0,127" will become ["0","127"])
    String[] values = rawString.split("\t");
    // If we have 2 bytes:
    int x = int(values[0]);
    int y = int(values[1]);
    xpos = map(y, 0, 150, 0, width);
    ypos = map(x, 0, 150, 0, height);
    serialCount = 0;
  }
  catch(Exception e) {
    println("Error parsing string from Serial:");
    e.printStackTrace();
  }
}