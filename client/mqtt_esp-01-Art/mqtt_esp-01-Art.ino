#include <Arduino.h>

/*
  Generic MQTT to ESP-01 resetter client
*/

#include <ESP8266WiFi.h>
#include <PubSubClient.h>


const char ssid[] = "TRAILROADWAY";
const char password[] = "MALLETCAMERA";
const char mqtt_server[] = "10.0.1.5";
const char ID[] = "Art-36";

WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[50];
int value = 0;

void setup() {
  pinMode(2, OUTPUT);     // this thing connects to RESET on a mainboard
  digitalWrite(2, HIGH);
  // Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
}

void setup_wifi() {

  delay(10);
  // We start by connecting to a WiFi network
  // Serial.println();
  // Serial.print("Connecting to ");
  // Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    // Serial.print(".");
  }

  // Serial.println("");
  // Serial.println("WiFi connected");
  // Serial.println("IP address: ");
  // Serial.println(WiFi.localIP());
}

void callback(char topic[], byte payload[], unsigned int length) {
  // Serial.print("Message arrived [");
  // Serial.print(topic);
  // Serial.print("] ");
  // for (int i = 0; i < length; i++) {
    // Serial.print((char)payload[i]);
  // }
  // Serial.println();

  // Here's what we do if we recieve "rst"
  if ((char)payload[0] == 'r' && (char)payload[1] == 's' && (char)payload[2] == 't') {
    // Serial.println("RST recieved");
    snprintf (msg, 75, "2", value);
    // Serial.print("Publish message: ");
    // Serial.println(msg);
    client.publish(ID, msg);
    digitalWrite(2, LOW);
    delay(222);
    digitalWrite(2, HIGH);
  // We get "rep" messare. Call back that we're alive
  } else if ((char)payload[0] == 'r' && (char)payload[1] == 'e' && (char)payload[2] == 'p') {
    snprintf (msg, 75, "1", value);
    // Serial.print("Gor \"rep\", publish message: ");
    // Serial.println(msg);
    client.publish(ID, msg);
  }
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    // Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect(ID, "rst202", "MALLETCAMERA",ID,0,0,"3")) {
      // Serial.println("connected");
      // Once connected, publish an announcement...
      client.publish(ID, "0");
      // ... and resubscribe
//      char Topic[50];
      char top[] = "/rst/";
      char Topic[50] = "/rst/";
      // Serial.println(top);
      // Serial.println(Topic);
      for (int i=0; i<sizeof(ID); i++) {
        Topic[sizeof(top)+i-1] = ID[i];
      }
      client.subscribe("/rst");
      // Serial.println("Sub to: ");
      // Serial.println(top);
      client.subscribe(Topic);
      // Serial.println(Topic);
    } else {
      // Serial.print("failed, rc=");
      // Serial.print(client.state());
      // Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  long now = millis();
  if (now - lastMsg > 5000) {
    lastMsg = now;
    ++value;
    snprintf (msg, 75, "1", value);
    // Serial.print("Publish message: ");
    // Serial.println(msg);
    client.publish(ID, msg);  // poking 1 to tell we're up
  }
}
