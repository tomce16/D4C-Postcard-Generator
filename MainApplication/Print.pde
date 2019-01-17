// In order to automatically print the postcard you need to:
// 1. Download the PDFtoPrinter.exe file from http://www.columbia.edu/~em36/pdftoprinter.html
// 2. Change the addreses where you put the PDFtoPrinter.exe file and your application (at 21 line)

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
    // ! Write here your own addresses to the PDFtoPrinter.exe file, and where you are saving the postcards PDF !
    output.println("\"C:\\Temp\\PDFtoPrinter.exe\" \"C:\\Users\\Tomas\\Google Drive\\TUE\\Design for creatives\\Token\\D4C-Token-Generator\\MainApplication\\Postcard"+stamp+".pdf\"");
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
    println(" PDF created");
    printing= true; 

    //Launching the script to print the postcard
    // !Do not forget to change the address where your application is putted!
    launch("C:\\Users\\Tomas\\Google Drive\\TUE\\Design for creatives\\Token\\D4C-Token-Generator\\MainApplication\\print.bat");

    //Add to the table current design variables
    AddDataToTable(CardTable);
    println("end");
  } else {
    printing= true;
  }
}
