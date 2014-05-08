#define DATA 4
#define LATCH_1 2
#define CLOCK 3
#define INPUT_LENGTH 8
#define OUTPUT_LENGTH 16

int inputs[INPUT_LENGTH] = {A0, A1, A2, A3, A4, A5, A6, A7};


void setup()
{
    pinMode(DATA, OUTPUT);
    pinMode(LATCH_1, OUTPUT);
    pinMode(CLOCK, OUTPUT);
    for (int i = 0; i < sizeof(inputs); i++)
    {
        pinMode(inputs[i], INPUT);
    }

    Serial.begin(9600);
    delay(10);

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
    int data[OUTPUT_LENGTH][INPUT_LENGTH];
    digitalWrite(DATA,HIGH);
    shift();
    digitalWrite(DATA,LOW);
    delay(10);
    int count = 0;
    for (int j = 0; j < sizeof(inputs); j++)
    {
        data[0][j] = analogRead(inputs[j]);
    }

    
    for (int i = 1; i < OUTPUT_LENGTH;i++) {

        shift();
        for (int j = 0; j < sizeof(inputs); j++)

        {
            data[i][j] = analogRead(inputs[j]);        
        }
    }
    for (int i = 0; i < OUTPUT_LENGTH;i++) {
      String tmp;
      tmp = tmp +" "+count+":";
      for (int j = 0; j < sizeof(inputs); j++) {
        tmp+=data[i][j];
        tmp+=",";
        }
        tmp+=";";
        count ++;

        Serial.println(tmp);
        //Serial.println("");
    }

}


