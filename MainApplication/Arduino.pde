//Communication to Arduino and data from token extraction

Serial myPort;      // Initializing a vairable named 'myPort' for serial communication

String[] Name;     
String[] Data;

void initiallizeComunication(String port) {
  myPort  =  new Serial (this, port, 9600); // Set the com port and the baud rate according to the Arduino IDE
  myPort.bufferUntil ( '\n' );   // Receiving the data from the Arduino IDE
}

void serialEvent  (Serial myPort) {

  try {
    String a = myPort.readStringUntil ( '\n' );  //Get the data string from arduino
    a = a.trim();
    print("Arduino -> "); 
    println(a);
    if (a.length()>4) {
      if (a.substring(0, 4).equals("Send")) { // The start of data transfering 
        ExtractData(a); // Get exact values from data string
        cards.redrawCard();
      } else if (a.substring(0, 4).equals("#Rea")) { // The command which means that the scanner read the token
        delay(250);
        myPort.write("Send\n"); // Command scanner to send the data what it got from token
        Screen=1; // Go to animation screen
      }
    }
  }
  catch(RuntimeException e) {
    e.printStackTrace();
  }
}
