import mqtt.*;
MQTTClient mqtt;

JSONArray Pcs;

int parkSize = 90;

Workstation[] pc = new Workstation[parkSize];
float WIDTH = 40;
float HEIGHT = 80;

void setup() {
  mqtt = new MQTTClient(this);
  mqtt.connect("mqtt://admin:Q!w2e3r4@10.0.1.5","monitor");
  mqtt.subscribe("#");
  Pcs = new JSONArray();
  size(1600,800);
  for (int i = 0 ; i < parkSize ; i++) {
    pc[i] = new Workstation(i);
    JSONObject Pc = new JSONObject();
    Pc.setInt("id", i);
    Pc.setString("name", pc[i].name);
    Pc.setString("user", pc[i].user);
    Pc.setInt("i", pc[i].i);
    Pc.setInt("j", pc[i].j);
    Pc.setBoolean("exists",pc[i].exists);
    Pc.setInt("lastOnlineY", pc[i].lastonline[0]);
    Pc.setInt("lastOnlineM", pc[i].lastonline[1]);
    Pc.setInt("lastOnlineD", pc[i].lastonline[2]);
    Pc.setInt("lastOnlineh", pc[i].lastonline[3]);
    Pc.setInt("lastOnlinem", pc[i].lastonline[4]);
    Pc.setInt("lastOnlines", pc[i].lastonline[5]);

    Pcs.setJSONObject(i, Pc);
  }
  saveJSONArray(Pcs,"data/pcs.json");

}

void draw() {
  background(100);
  translate(0,0);
  pc[36].exists = true;
  for (int i = 1 ; i < pc.length ; i++) {
    pc[i].display();
  }
}


void messageReceived(String topic, byte[] payload) {
    int id = int(topic.substring(topic.indexOf("-")+1,topic.indexOf("-")+3));
    if (payload[0] == '1'){
      pc[id].setLastOnline();
    }
}
