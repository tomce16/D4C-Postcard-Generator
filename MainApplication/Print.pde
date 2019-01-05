

String stamp = ""+(int) random(0, 10000000); // Stamp to make a different pdf names
boolean printing = false; // Is the postcard currently printing


void PrintFile() {

  if (printing == false) {
    if (myPort != null) myPort.write("Done\n"); // write to the scanner that visitor can take the postcard

    //Redraw the postcard for the right size 
    cards.DrawPDF();

    //Write a little script that will print the postcard
    PrintWriter output; 
    output = createWriter("print.bat"); 
    output.println("\"C:\\Temp\\PDFtoPrinter.exe\" \"C:\\Users\\Tomas\\Google Drive\\TUE\\Design for creatives\\Token\\D4C-Token-Generator\\MainApplication\\Postcard"+stamp+".pdf\"");
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    println(" PDF created");
    printing= true; 

    //Launching the script to print the postcard
    launch("C:\\Users\\Tomas\\Google Drive\\TUE\\Design for creatives\\Token\\D4C-Token-Generator\\MainApplication\\print.bat");

    //Add to the table current design variables
    AddDataToTable(CardTable);
    println("end");
  } else {
    printing= true;
  }
}
