// Other functions that did not fit elsewhere

void ExtractData(String a){
  
 Data = new String[0];
 Name = new String[0];  
 
   String name = "";
   String d = "";
   int count = 0;
   boolean collectName = false;
   boolean collectData = false;
   
   a = a + '#'; //To fix problem that function do not know when to append data to arrays
   
  for(int i = 0; i < a.length();i++){
   println(a.charAt(i)); 
   
   if(a.charAt(i) == '#'){ //Start extracting the data
     
     if(count != 0){
     println("Saving ", name, " ", d);
     Data = append(Data, d);
     d = "";
     Name = append(Name, name);
     name = "";
     }
     
     collectName = true;
     collectData = false;
     count++;
     
   }else if(a.charAt(i) == ':'){
      println("Got ", name);
     collectData = true;
     collectName= false;
   }
   else if(collectName){
   name = name + a.charAt(i);
   }else if(collectData){
    d = d + a.charAt(i); 
   }
   
  }//End of for loop
                      
   // Put the got data to variables 
   
  for(int i = 0; i < count-1;i++){
   println(i, "# Name ", Name[i], " Data ", Data[i]); 
   if(Name[i].equals("c")){
     c = int(Data[i].substring(0,1));
     println("Card color = ", c);
   }else if (Name[i].equals("e")){
     e = int(Data[i].substring(0,1));
     println("Card elements = ", e);
   }else if (Name[i].equals("s")){
     s = int(Data[i].substring(0,1));
     println("Card  size = ", s);
   }
  }
  
}

//Start everything from the start
void Restart(){
 Screen = 0;
 if(myPort != null)  myPort.write("Read\n");
 stamp = ""+(int) random(0,10000000);
 printing= false; 
}
