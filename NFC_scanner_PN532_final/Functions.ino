// Reset rc array. Prepare for new incoming data
void deleteRcData() {
  Serial.println("Deleting the rc array");
  for (int i = 0; i < q; i++) {
    rc[i] = "";
  }
  q = 0;
}

// Read Token
void ReadTag() {
  uint8_t success;
  uint8_t uid[] = { 0, 0, 0, 0, 0, 0, 0 };  // Buffer to store the returned UID
  uint8_t uidLength;                        // Length of the UID (4 or 7 bytes depending on ISO14443A card type)
  Serial.println("Lets try to scan");

  success = nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, uid, &uidLength);

  if (success) {

    fullColor(strip.Color(0, 0 , 0), 10);
    TokenStatus = 1;
    Serial.println("Success");
    // Display some basic information about the card
    Serial.println("Found an ISO14443A card");
    Serial.print("  UID Length: "); Serial.print(uidLength, DEC); Serial.println(" bytes");
    Serial.print("  UID Value: ");
    nfc.PrintHex(uid, uidLength);
    Serial.println("");
    if (uidLength == 7)
    {
      uint8_t data[32];

      //Start reading the data
      for (uint8_t i = 0; i < 42; i++)
      {
        success = nfc.ntag2xx_ReadPage(i, data);

        // Display the current page number
        Serial.print("PAGE ");
        if (i < 10)
        {
          Serial.print("0");
          Serial.print(i);
        }
        else
        {
          Serial.print(i);
        }
        Serial.print(": ");

        // Display the results, depending on 'success'
        if (success)
        {
          // Dump the page data
          nfc.PrintHexChar(data, 4);
          Response(data, 4); //Put data in the rc[] array
        }
        else
        {
          Serial.println("Unable to read the requested page!");
        }
      }

      //FOR DEBUG. Print data that we got.
      Serial.println("Scanned data");
      for (int i = 15; i < q; i++) {
        Serial.print(rc[i]);
      }
      Serial.println("");

      //This is important for Serial communication with computer.
      //When Proccessing will get this line, it will ask the scanner to send the data that it read
      Serial.println("#Read-done");

    }
    else
    {
      Serial.println("This doesn't seem to be an NTAG203 tag (UUID length != 7 bytes)!");
    }
    success = false;
  }

} // End of ReadTag()

void WriteTag(char * s) {
  uint8_t success;
  uint8_t uid[] = { 0, 0, 0, 0, 0, 0, 0 };  // Buffer to store the returned UID
  uint8_t uidLength;                        // Length of the UID (4 or 7 bytes depending on ISO14443A card type)
  uint8_t dataLength;


  //FOR DEBUG. Print what data we are writing
  Serial.println(" ");
  Serial.println("s @Write -");
  for (int i = 0; i < 25; i++) {
    Serial.print(s[i]);
  }
  Serial.println(" ");
  Serial.println(" ");

  // For a http://www. url:
  uint8_t ndefprefix = NDEF_URIPREFIX_HTTP_WWWDOT;

  // 1.) Wait for an NTAG203 card.  When one is found 'uid' will be populated with
  // the UID, and uidLength will indicate the size of the UID (normally 7)
  success = nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, uid, &uidLength);

  // It seems we found a valid ISO14443A Tag!
  if (success)
  {
    // 2.) Display some basic information about the card
    Serial.println("Found an ISO14443A card");
    Serial.print("  UID Length: "); Serial.print(uidLength, DEC); Serial.println(" bytes");
    Serial.print("  UID Value: ");
    nfc.PrintHex(uid, uidLength);
    Serial.println("");

    if (uidLength != 7)
    {
      Serial.println("This doesn't seem to be an NTAG203 tag (UUID length != 7 bytes)!");
    }
    else
    {
      uint8_t data[32];

      // We probably have an NTAG2xx card (though it could be Ultralight as well)
      Serial.println("Seems to be an NTAG2xx tag (7 byte UID)");
      // 3.) Check if the NDEF Capability Container (CC) bits are already set
      // in OTP memory (page 3)
      memset(data, 0, 4);
      success = nfc.ntag2xx_ReadPage(3, data);
      if (!success)
      {
        Serial.println("Unable to read the Capability Container (page 3)");
        return;
      }
      else
      {
        // If the tag has already been formatted as NDEF, byte 0 should be:
        // Byte 0 = Magic Number (0xE1)
        // Byte 1 = NDEF Version (Should be 0x10)
        // Byte 2 = Data Area Size (value * 8 bytes)
        // Byte 3 = Read/Write Access (0x00 for full read and write)
        if (!((data[0] == 0xE1) && (data[1] == 0x10)))
        {
          Serial.println("This doesn't seem to be an NDEF formatted tag.");
          Serial.println("Page 3 should start with 0xE1 0x10.");
        }
        else
        {
          // 4.) Determine and display the data area size
          dataLength = data[2] * 8;
          Serial.print("Tag is NDEF formatted. Data area size = ");
          Serial.print(dataLength);
          Serial.println(" bytes");

          // 5.) Erase the old data area
          Serial.print("Erasing previous data area ");
          for (uint8_t i = 4; i < (dataLength / 4) + 4; i++)
          {
            memset(data, 0, 4);
            success = nfc.ntag2xx_WritePage(i, data);
            Serial.print(".");
            if (!success)
            {
              Serial.println(" ERROR!");
              return;
            }
          }
          Serial.println(" DONE!");

          // 6.) Try to add a new NDEF URI record
          Serial.print("Writing URI as NDEF Record ... ");
          success = nfc.ntag2xx_WriteNDEFURI(ndefprefix, s, dataLength);
          if (success)
          {
            Serial.println("DONE!");
          }
          else
          {
            Serial.println("ERROR! (URI length?)");
          }

        } // CC contents NDEF record check
      } // CC page read check
    } // UUID length check

  } // Start waiting for a new ISO14443A tag

}

//Reseting Token and putting the default data on it
void ResetTag() {
  uint8_t success;
  uint8_t uid[] = { 0, 0, 0, 0, 0, 0, 0 };  // Buffer to store the returned UID
  uint8_t uidLength;                        // Length of the UID (4 or 7 bytes depending on ISO14443A card type)
  uint8_t dataLength;

  // For a http://www. url:
  uint8_t ndefprefix = NDEF_URIPREFIX_HTTP_WWWDOT;
  char * url = "eindhovenmuseum.nl";

  // 1.) Wait for an NTAG203 card.  When one is found 'uid' will be populated with
  // the UID, and uidLength will indicate the size of the UID (normally 7)
  success = nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, uid, &uidLength);

  // It seems we found a valid ISO14443A Tag!
  if (success)
  {
    // 2.) Display some basic information about the card
    Serial.println("Found an ISO14443A card");
    Serial.print("  UID Length: "); Serial.print(uidLength, DEC); Serial.println(" bytes");
    Serial.print("  UID Value: ");
    nfc.PrintHex(uid, uidLength);
    Serial.println("");

    if (uidLength != 7)
    {
      Serial.println("This doesn't seem to be an NTAG203 tag (UUID length != 7 bytes)!");
    }
    else
    {
      uint8_t data[32];

      // We probably have an NTAG2xx card (though it could be Ultralight as well)
      Serial.println("Seems to be an NTAG2xx tag (7 byte UID)");
      // 3.) Check if the NDEF Capability Container (CC) bits are already set
      // in OTP memory (page 3)
      memset(data, 0, 4);
      success = nfc.ntag2xx_ReadPage(3, data);
      if (!success)
      {
        Serial.println("Unable to read the Capability Container (page 3)");
        return;
      }
      else
      {
        // If the tag has already been formatted as NDEF, byte 0 should be:
        // Byte 0 = Magic Number (0xE1)
        // Byte 1 = NDEF Version (Should be 0x10)
        // Byte 2 = Data Area Size (value * 8 bytes)
        // Byte 3 = Read/Write Access (0x00 for full read and write)
        if (!((data[0] == 0xE1) && (data[1] == 0x10)))
        {
          Serial.println("This doesn't seem to be an NDEF formatted tag.");
          Serial.println("Page 3 should start with 0xE1 0x10.");
        }
        else
        {
          // 4.) Determine and display the data area size
          dataLength = data[2] * 8;
          Serial.print("Tag is NDEF formatted. Data area size = ");
          Serial.print(dataLength);
          Serial.println(" bytes");

          // 5.) Erase the old data area
          Serial.print("Erasing previous data area ");
          for (uint8_t i = 4; i < (dataLength / 4) + 4; i++)
          {
            memset(data, 0, 4);
            success = nfc.ntag2xx_WritePage(i, data);
            Serial.print(".");
            if (!success)
            {
              Serial.println(" ERROR!");
              return;
            }
          }
          Serial.println(" DONE!");

          // 6.) Try to add a new NDEF URI record
          Serial.print("Writing URI as NDEF Record ... ");
          success = nfc.ntag2xx_WriteNDEFURI(ndefprefix, url, dataLength);
          if (success)
          {
            Serial.println("DONE!");
          }
          else
          {
            Serial.println("ERROR! (URI length?)");
          }

        } // CC contents NDEF record check
      } // CC page read check
    } // UUID length check


  } // Start waiting for a new ISO14443A tag

}

void SendData() {
  Serial.print("Send");
  Serial.println(rc);
}

String addData(String a) {
  Serial.println("");
  Serial.print("a - "); Serial.println(a);
  String wr = "";
  //Put the data we had before to the String
  for (int i = findIndexOfBasic(); i < q - 1; i++) {
    wr = wr + rc[i];
  }

  //Serial communication for DEBUG PURPOSES
  Serial.println(" ");
  Serial.print("wr -");
  Serial.print(wr);
  Serial.println(" ");

  //combine the old data with new one
  wr = wr + a;

  //Serial communication for DEBUG PURPOSES
  Serial.println(" ");
  Serial.print("Combined wr -");
  Serial.print(wr);
  Serial.println(" ");
  return wr;
}

//Extract calues from got line of the data
String extractData(String b) {
  int start = b.indexOf('(');
  int finish = b.indexOf(')');
  Serial.println(b.substring((start + 1), finish));
  return b.substring((start + 1), finish);
}

//Find where in data line the website name starts.
//It is made to ensure the qualaty of the data,
//because sometimes some random values stucks in the
// beggining or the end of the data line

int findIndexOfBasic() {
  char * p;
  const char* Text = "eindhovenm";
  p = strstr (rc, Text);
  Serial.println(" Eindhoven index - ");
  Serial.print((int) (p - rc));
  return (int) (p - rc);
}

//Set all LEDS in one colour
void fullColor(uint32_t c, uint8_t wait) {

  for (uint16_t i = 0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, c );
  }
  strip.show();
  delay(wait);
}

//Set LED strip moving effect 
void ColorOnColor(uint32_t c1, uint32_t c2, uint8_t wait, uint8_t whiteSpeed ) {

  if (whiteLength >= strip.numPixels()) whiteLength = strip.numPixels() - 1;
  
  int loops = 1;
  int loopNum = 0;

  static unsigned long lastTime = 0;

  while (true) {
    for (uint16_t i = 0; i < strip.numPixels(); i++) {
      if ((i >= tail && i <= head) || (tail > head && i >= tail) || (tail > head && i <= head) ) {
        strip.setPixelColor(i, c1);
      }
      else {
        strip.setPixelColor(i, c2);
      }

    }

    if (millis() - lastTime > whiteSpeed) {
      head++;
      tail++;
      if (head == strip.numPixels()) {
        loopNum++;
      }
      lastTime = millis();
    }

    if (loopNum == loops) return;
    head %= strip.numPixels();
    tail %= strip.numPixels();
    strip.show();
    delay(wait);
  }
}
