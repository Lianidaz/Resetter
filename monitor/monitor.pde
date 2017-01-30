import mqtt.*;
MQTTClient mqtt;

JSONArray Pcs;

int parkSize = 90;

Workstation[] pc = new Workstation[parkSize];
float WIDTH = 40;
float HEIGHT = 80;

boolean edit = false;

void setup() {
  mqtt = new MQTTClient(this);
  mqtt.connect("mqtt://admin:Q!w2e3r4@10.0.1.5","monitor");
  mqtt.subscribe("#");
  Pcs = loadJSONArray("pcs.json");
  size(1400,880);
  for (int i = 0 ; i < parkSize ; i++) {
    pc[i] = new Workstation(i);
    pc[i].readJSON(i);
  }

}

void draw() {
  background(100);
  translate(200,0);
  // canvas();
  for (int i = 1 ; i < pc.length ; i++) {
    pc[i].display();
  }
}

void mousePressed(){

}


void messageReceived(String topic, byte[] payload) {
    int id = int(topic.substring(topic.indexOf("-")+1,topic.indexOf("-")+3));
    if (payload[0] == '1'){
      pc[id].setLastOnline();
      writeJSON(id);
    }
}
