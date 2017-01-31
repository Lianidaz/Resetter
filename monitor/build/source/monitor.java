import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import interfascia.*; 
import mqtt.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class monitor extends PApplet {



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

public void setup() {
  mqtt = new MQTTClient(this);
  mqtt.connect("mqtt://admin:Q!w2e3r4@10.0.1.5","monitor");
  mqtt.subscribe("#");
  setupGui();
  Pcs = loadJSONArray("pcs.json");
  
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

public void draw() {
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

public void mousePressed(){
  int cell = cellIsPc(overCell);
  for (int i = 1 ; i < pc.length ; i++) {
    pc[i].selected = false;
  }
  if (cell >= 0) {
    pc[cell].selected = true;
  }
}


public void messageReceived(String topic, byte[] payload) {
    int id = PApplet.parseInt(topic.substring(topic.indexOf("-")+1,topic.indexOf("-")+3));
    if (payload[0] == '1'){
      pc[id].setLastOnline();
      writeJSON(id);
    }
}
class Workstation {
  int id;
  String name, user;
  float x, y;
  int i, j;
  boolean exists, on, selected;
  int[] lastReset = {0,0,0,0,0,0};   // date Y-M-D h-m-s
  int[] lastonline = {0,0,0,0,0,0};   // date Y-M-D h-m-s


  Workstation(int _id) {
    id=_id;
    if (_id<=9){
      name="Art-0" + id;
    } else {
      name="Art-" + id;
    }
    user="none";
    x=WIDTH*i;
    y=HEIGHT*j;
    on = false;
    selected = false;
    exists = false;
  }

  public void display(){
    if (exists) {
      stroke(0);
      if (timeNow()-timeSec(lastonline)<=10) {
        fill(8,252,53);
      } else {
        fill(252,12,33);
      }
      pushMatrix();
      translate(WIDTH*i+WIDTH/2,HEIGHT*j+HEIGHT/2);
      rect(-WIDTH/2+2,-HEIGHT/2+2,WIDTH-2,HEIGHT-2,5,5,5,5);
      fill(0);
      textSize(HEIGHT/4);
      rotate(-PI/2);
      textAlign(CENTER,CENTER);
      text(name,0,0);
      popMatrix();
    }
    if (selected) {
      text(name,-150,30);
    }
  }

  public void setLastOnline(){
    lastonline[0] = year();
    lastonline[1] = month();
    lastonline[2] = day();
    lastonline[3] = hour();
    lastonline[4] = minute();
    lastonline[5] = second();
  }

  public void readJSON(int a) {
        JSONObject Pc = Pcs.getJSONObject(a);
        Pc.getInt("id");
        name = Pc.getString("name");
        user = Pc.getString("user");
        i = Pc.getInt("i");
        j = Pc.getInt("j");
        exists = Pc.getBoolean("exists");
        lastonline[0] = Pc.getInt("lastOnlineY");
        lastonline[1] = Pc.getInt("lastOnlineM");
        lastonline[2] = Pc.getInt("lastOnlineD");
        lastonline[3] = Pc.getInt("lastOnlineh");
        lastonline[4] = Pc.getInt("lastOnlinem");
        lastonline[5] = Pc.getInt("lastOnlines");
  }

}

class Cell {
  int i, j, pcID;
  boolean mouseover;

  Cell(int _i, int _j) {
    i = _i;
    j= _j;
    mouseover = false;
  }
  public void show() {
    if (mouseover) {
      fill(21,12,222,60);
      noStroke();
      pushMatrix();
      translate(WIDTH*i+WIDTH/2,HEIGHT*j+HEIGHT/2);
      rect(-WIDTH/2+2,-HEIGHT/2+2,WIDTH-2,HEIGHT-2,5,5,5,5);
      popMatrix();
    }
  }
}
public int timeSec(int[] moment){
  int t = moment[3]*3600+moment[4]*60+moment[5];
  return t;
}

public int timeNow(){
  int t = hour()*3600+minute()*60+second();
  return t;
}

public void  canvas(boolean grid) {
  if (grid){
    stroke(11);
    for (int i = 0 ; i <= 30 ; i++) {
      for (int j = 0 ; j < height/HEIGHT; j++ ) {
        line(i*WIDTH,0,i*WIDTH,height);
        line(0,j*HEIGHT,width,j*HEIGHT);
      }
    }
  }
}

public void writeJSON(int i){
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

saveJSONArray(Pcs,"data/pcs.json");
}

public int cellIsPc(int celli) {
  int res = -1;
  if (celli >= 0) {
    for (int i = 0 ; i < parkSize ; i++ ) {
      if ( cells[celli].i == pc[i].i && cells[celli].j == pc[i].j ) {
        res = i;
      }
    }
  }
  return res;
}
GUIController guiCtrl;
IFTextField nameField, userField;

public void setupGui() {
  pushMatrix();
  translate(-200,0);
  guiCtrl = new GUIController(this);
  nameField = new IFTextField("name", 20, 20, 100);
  userField = new IFTextField("user", 20, 50, 100);

  guiCtrl.add(nameField);
  guiCtrl.add(userField);
  popMatrix();

}
  public void settings() {  size(1400,880); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "monitor" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
