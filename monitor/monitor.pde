
import mqtt.*;
MQTTClient mqtt;

JSONArray Pcs;

int parkSize = 90;
int gridX = 30;
int gridY = 11;
int overCell = -1;

Workstation[] pc = new Workstation[parkSize];
Cell[] cells = new Cell[(gridX*gridY)];
float WIDTH = 40;
float HEIGHT = 80;

boolean edit = false;

void setup() {
  mqtt = new MQTTClient(this);
  mqtt.connect("mqtt://admin:Q!w2e3r4@10.0.1.5","monitor");
  mqtt.subscribe("#");
  setupGui();
  Pcs = loadJSONArray("pcs.json");
  size(1400,880);
  for (int i = 0 ; i < parkSize ; i++) {
    pc[i] = new Workstation(i);
    pc[i].readJSON(i);
  }
  int cellcounter = 0;
  for (int i = 0 ; i < gridX ; i++) {
    for (int j = 0 ; j < gridY ; j++) {
      cells[cellcounter] = new Cell(i,j);
      cellcounter++;
    }
  }

}

void draw() {
  background(100);
  translate(200,0);
  noStroke();
  fill(159);
  rect(-200,0,200,height);
  canvas(false);
  for (int i = 1 ; i < pc.length ; i++) {
    pc[i].display();
  }
  for (int i = 0 ; i < gridX*gridY ; i++){
    if (mouseX-200 >= WIDTH*cells[i].i+2 && mouseX-200 <= WIDTH*cells[i].i+WIDTH-2 &&
      mouseY >= HEIGHT*cells[i].j+2 && mouseY <= HEIGHT*cells[i].j+HEIGHT-2) {
      cells[i].mouseover = true;
      overCell = i;
    } else {
      cells[i].mouseover = false;
      // overCell = -1;
    }
    cells[i].show();
  }
}

void mousePressed(){
  int cell = cellIsPc(overCell);
  for (int i = 1 ; i < pc.length ; i++) {
    pc[i].selected = false;
  }
  if (cell >= 0) {
    pc[cell].selected = true;
  }
}


void messageReceived(String topic, byte[] payload) {
    int id = int(topic.substring(topic.indexOf("-")+1,topic.indexOf("-")+3));
    if (payload[0] == '1'){
      pc[id].setLastOnline();
      writeJSON(id);
    }
}
