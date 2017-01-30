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
  Pcs = loadJSONArray("pcs.json");
  size(1200,880);
  for (int i = 0 ; i < parkSize ; i++) {
    pc[i] = new Workstation(i);

    JSONObject Pc = Pcs.getJSONObject(i);
    Pc.getInt("id");
    pc[i].name = Pc.getString("name");
    pc[i].user = Pc.getString("user");
    pc[i].i = Pc.getInt("i");
    pc[i].j = Pc.getInt("j");
    pc[i].exists = Pc.getBoolean("exists");
    pc[i].lastonline[0] = Pc.getInt("lastOnlineY");
    pc[i].lastonline[1] = Pc.getInt("lastOnlineM");
    pc[i].lastonline[2] = Pc.getInt("lastOnlineD");
    pc[i].lastonline[3] = Pc.getInt("lastOnlineh");
    pc[i].lastonline[4] = Pc.getInt("lastOnlinem");
    pc[i].lastonline[5] = Pc.getInt("lastOnlines");

  }

}

void draw() {
  background(100);
  canvas();
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
