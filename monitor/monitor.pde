
import mqtt.*;
import g4p_controls.*;
// import controlP5.*;

int wid = 40;
int hei = 80;
int gridX = 30;
int gridY = 11;
int parkSize = 45;
int freeID = 0;

int SZ;

int selectedCell = -1;

MQTTClient mqtt;
// ControlP5 cp5;
Pc[] pcs = new Pc[parkSize];
Cell[] cells = new Cell[(gridX*gridY)];

// JSONArray Pcs;

void setup(){
  size(1400,880);
  SZ = width - wid * gridX;
  // cp5 = new ControlP5(this);
  // cp5.addTextfield("name").setPosition(-170,50).setSize(140,30).setAutoClear(false);
  // cp5.addTextfield("user").setPosition(-170,100).setSize(140,30).setAutoClear(false);
  // cp5.addBang("save").setPosition(-170,height-80).setSize(60,50);
  // cp5.addBang("cancel").setPosition(-90,height-80).setSize(60,50);
  // mqtt = new MQTTClient(this);
  // mqtt.connect("mqtt://admin:Q!w2e3r4@10.0.1.5","monitor");
  // mqtt.subscribe("#");
  // controls();
  int counter = 0;
  for (int i = 0 ; i < parkSize ; i++ ){
    pcs[i] = new Pc();
  }
  for (int j = 0 ; j < gridY ; j++ ){
    for ( int i = 0 ; i < gridX ; i++ ){
      cells[counter] = new Cell(counter,i,j);
      counter++;
    }
  }
  createGUI();
  setgui();

  println("parkSize = " + parkSize + " cells: " + cells.length);

}

void draw() {
  background(122);
  noStroke();
  fill(66);
  rect(0,0,SZ,height);
  for (int i = 0 ; i < cells.length ; i++) {
    cells[i].show();
  }
}

void mousePressed(){
  if (mouseX>200){
    for (int i = 0 ; i < cells.length ; i++) {
      // println(cells[i].pcID);
      if (cells[i].mouseover()) {
        cells[i].selected = !cells[i].selected;
        if (cells[i].selected) {
           selectedCell = i;
           if (cells[selectedCell].isPc) {
             namefield.setText(pcs[cells[selectedCell].pcID].name);
             userfield.setText(pcs[cells[selectedCell].pcID].user);
             exists_checkbox.setSelected(pcs[cells[selectedCell].pcID].exists);
           } else {
             namefield.setText("");
             userfield.setText("");
             exists_checkbox.setSelected(false);
           }
         } else {
            selectedCell = -1;
         }
      } else { cells[i].selected = false; }
    }
  }
  println(selectedCell);
}

// void messageReceived(String topic, byte[] payload) {
//   for (int i = 0 ; i < pcs.length ; i++) {
//     if (pcs[i].name = topic);
//       pc[i].setLastOn();
//   }
// }
