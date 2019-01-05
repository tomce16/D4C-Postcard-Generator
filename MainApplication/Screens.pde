// EVERYTHING CONNECTED TO SCREENS

//Screens variables
boolean transition = false;
Movie loadingVideo;
Movie waitingVideo;
Movie printingVideo;

void initiliazeVideos() {
  waitingVideo = new Movie(this, "WaitingForTheToken.mp4"); // For now random gif as placeholder
  waitingVideo.loop();
  loadingVideo = new Movie(this, "LoadingToken.mp4"); // For now random gif as placeholder
  loadingVideo.noLoop();
  printingVideo = new Movie(this, "PrintingPostcard.mp4"); // For now random gif as placeholder
  printingVideo.loop();
}

// Showing a video that asks to put the token to the scanner
void WaitingForToken() {
  background(#6dd99e);
  image( waitingVideo, width / 2 - 200, height / 2 - 200, 400, 400);
}

// Showing a video that shows that we reading token and "analyzing" the data
void LoadingTokenData() {
  background(#84CEDB);
  image( loadingVideo, 0, 0, 1920, 1080);
}

// Showing a video that shows that computer is printing the postcard
void PrintingVideo() {
  background(#fbe609);
  image( printingVideo, width / 2 - 200, height / 2 - 200, 400, 400);
}

//Function that shows the right interface
void showScreen() {
  switch(Screen) {
  case 0: // 0 - Scan screen
    WaitingForToken();
    loadingVideo.stop();
    break;
  case 1: // 1 - Loading data screen
    LoadingTokenData(); 

    loadingVideo.play();
    if (loadingVideo.time() > 7) Screen++;

    break;
  case 2: // 2 - Card selection screen 

    noStroke();
    background(245);
    fill(0);
    textAlign(CENTER);
    textSize(32);

    drawCards();
    showButtons();
    fill(0);
    text("By the data we have", width/7*5, height/3);
    text("we believe that this is the card you will like it.", width/7*5, height/3+50);

    textSize(60);
    text("Do you like this card?", width/7*5, height/2+32);

    textSize(25);
    fill(40);
    text("Let's print it!", width/7*5-160, height/12*9-15);
    text("Let's customize!", width/7*5+240, height/12*9-15);

    break;
  case 3: // 3 -  Printing screen
    PrintingVideo(); 
    textSize(32);
    fill(0);
    text("Please wait until the postcard is printed!", width/2, height/2+180);
    PrintFile();
    fill(255);
    break;
  case 4:   // 4 - Thank you / Have a great time
    background(245, 0, 0);
    break;
  case 10:   // 10 - Customize your card
    background(245);
    drawCards();

    textSize(60);
    fill(0);
    text("Customize your own card!", width/7*5, height/5+32);

    CustomizeCard.display();
    break;
  default:             // Default executes if the case labels
    println("None");   // don't match the switch parameter
    break;
  }
}


//Function that starts when button "Continue" is pressed at Card selection part
void Select() {
  println("Select was clicked");
  Screen++; // After selection and button "Continue" press we will go to "After card selection" screen
}

//Function that is needed to play the videos
void movieEvent(Movie m) {
  m.read();
}
