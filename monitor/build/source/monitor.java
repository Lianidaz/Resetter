import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

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

Workstation[] pc = new Workstation[parkSize];
float WIDTH = 40;
float HEIGHT = 80;

public void setup() {
  mqtt = new MQTTClient(this);
  mqtt.connect("mqtt://admin:Q!w2e3r4@10.0.1.5","monitor");
  mqtt.subscribe("#");
  Pcs = loadJSONArray("pcs.json");
  
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

public void draw() {
  background(100);
  canvas();
  for (int i = 1 ; i < pc.length ; i++) {
    pc[i].display();
  }
}


public void messageReceived(String topic, byte[] payload) {
    int id = PApplet.parseInt(topic.substring(topic.indexOf("-")+1,topic.indexOf("-")+3));
    if (payload[0] == '1'){
      pc[id].setLastOnline();
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
      rect(-WIDTH/2,-HEIGHT/2,WIDTH-2,HEIGHT-2,5,5,5,5);
      fill(0);
      textSize(HEIGHT/4);
      rotate(-PI/2);
      textAlign(CENTER,CENTER);
      text(name,0,0);
      popMatrix();
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

}
public int timeSec(int[] moment){
  int t = moment[3]*3600+moment[4]*60+moment[5];
  return t;
}

public int timeNow(){
  int t = hour()*3600+minute()*60+second();
  return t;
}

public void  canvas() {
  stroke(11);
  for (int i = 0 ; i <= width/WIDTH ; i++) {
    text(i,(i*WIDTH-WIDTH/2),HEIGHT/2);
    for (int j = 0 ; j < height/HEIGHT; j++ ) {
      line(i*WIDTH,0,i*WIDTH,height);
      line(0,j*HEIGHT,width,j*HEIGHT);
    }
  }
}
  public void settings() {  size(1200,880); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "monitor" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
