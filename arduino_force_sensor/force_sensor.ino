#define DATA 2
#define LATCH_1 3
#define CLOCK 4
#define INPUT_LENGTH 10
#define OUTPUT_LENGTH 16
#define S0 7
#define S1 8
#define S2 9
#define S3 10
#define MUX_SIG A0
#define AVG_LENGTH 7

boolean con = false;

void setup()
{
    pinMode(DATA, OUTPUT);
    pinMode(LATCH_1, OUTPUT);
    pinMode(CLOCK, OUTPUT);

    pinMode(MUX_SIG, INPUT);

    pinMode(S0, OUTPUT); 
    pinMode(S1, OUTPUT); 
    pinMode(S2, OUTPUT); 
    pinMode(S3, OUTPUT); 
  
    digitalWrite(S0, LOW);
    digitalWrite(S1, LOW);
    digitalWrite(S2, LOW);
    digitalWrite(S3, LOW);

    Serial.begin(115200);

    Serial1.begin(38400);
    Serial1.setTimeout(3);
    delay(10);
//    Serial1.write('$$$');
//    //Peripherial Mode
//    Serial1.println('SM,0');
//    //PIN code authentication
//    Serial1.println('SA,4');
//    //Set the pin code to 1234
//    Serial1.println('SP,1234');
//    //Changes from HID to SPP protocol (support serial data)
//    Serial1.println('S~,0');
//    //Disables remote configuration over bluetooth
//    Serial1.println('ST,0');
//    //Set the friendly name to GripIt 
//    Serial1.println('SN,GripIt');
//    //Reset the bluetooth device
//    Serial1.println('R,1');

}

void shift()
{
        digitalWrite(LATCH_1, LOW);
        digitalWrite(CLOCK, HIGH);
        digitalWrite(CLOCK,LOW);
        digitalWrite(LATCH_1, HIGH);
}

void loop()
{
//    if (con == true) {
//      if (Serial1.find("COMPDISCONNECT")){
//            con = false;
//            Serial1.flush();
//      } else {
        int data[OUTPUT_LENGTH][INPUT_LENGTH];
        digitalWrite(DATA,HIGH);
        shift();
        digitalWrite(DATA,LOW);    
        for (int i = 0; i < OUTPUT_LENGTH;i++) {
          for (int j = 0; j < INPUT_LENGTH; j++) {        
            if(i >= 8) {
              data[(OUTPUT_LENGTH - i) + 7][j] = readMux(j);
            } else {
              data[i][j] = readMux(j);  
            }   
          }
          shift();
        }
        
        int count = 0;
        
        for (int i = 0; i < OUTPUT_LENGTH;i++) {
    
          String tmp;
          tmp = tmp +" "+count+":";
          for (int j = 0; j < INPUT_LENGTH; j++) {
            tmp+=data[i][j];
            tmp+=",";
          }
            tmp+=";";
            count ++;
    
            Serial1.println(tmp);
        }
//      }
//    } else {
//          if (Serial1.find("COMPCONNECT")){
//            con = true;
//            Serial1.flush();
//          }
//    }

}

int readMux(int channel){
  int controlPin[] = {S0, S1, S2, S3};

  int muxChannel[16][4]={
    {0,0,0,0}, //channel 0
    {1,0,0,0}, //channel 1
    {0,1,0,0}, //channel 2
    {1,1,0,0}, //channel 3
    {0,0,1,0}, //channel 4
    {1,0,1,0}, //channel 5
    {0,1,1,0}, //channel 6
    {1,1,1,0}, //channel 7
    {0,0,0,1}, //channel 8
    {1,0,0,1}, //channel 9
    {0,1,0,1}, //channel 10
    {1,1,0,1}, //channel 11
    {0,0,1,1}, //channel 12
    {1,0,1,1}, //channel 13
    {0,1,1,1}, //channel 14
    {1,1,1,1}  //channel 15
  };

  //loop through the 4 sig
  for(int i = 0; i < 4; i ++){
    digitalWrite(controlPin[i], muxChannel[channel][i]);
  }

  //read the value at the SIG pin
  int val = 0;
  for (int i = 0; i < AVG_LENGTH; i++)
  {
    val += analogRead(MUX_SIG);
  }

  //return the value
  return (val / AVG_LENGTH) ;
}


