import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import mqtt.*; 
import g4p_controls.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class monitor extends PApplet {




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

public void setup(){
  
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

public void draw() {
  background(122);
  noStroke();
  fill(66);
  rect(0,0,SZ,height);
  for (int i = 0 ; i < cells.length ; i++) {
    cells[i].show();
  }
}

public void mousePressed(){
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
  // println(selectedCell);
}

// void messageReceived(String topic, byte[] payload) {
//   for (int i = 0 ; i < pcs.length ; i++) {
//     if (pcs[i].name = topic);
//       pc[i].setLastOn();
//   }
// }
class Cell {
  int num, col, row, pcID;
  boolean isPc, selected;

  Cell(int _num, int _col, int _row) {
    num = _num;
    col = _col;
    row = _row;
    isPc = false;
    int pcID = -1;
  }
  public void show() {
    if (isPc) {
      if (pcs[pcID].on){
        fill(8,252,53);
      } else {
        fill(252,12,33);
      }
      strokeWeight(1);
      rect(SZ+col*wid+2, row*hei+2, wid-4, hei-4,5,5,5,5);
      pushMatrix();
      translate(SZ+col*wid+wid/2,row*hei+hei/2);
      textAlign(CENTER,CENTER);
      rotate(-PI/2);
      fill(0);
      textSize(18);
      text(pcs[pcID].name,0,0);
      popMatrix();
    }
    if (mouseover() || selected){
      if (selected){
        fill(21,222,222,60);
        noStroke();
        rect(SZ+col*wid+2, row*hei+2, wid-4, hei-4,5,5,5,5);
      } else {
        fill(21,52,222,60);
        noStroke();
        rect(SZ+col*wid+2, row*hei+2, wid-4, hei-4,5,5,5,5);
      }
    }
  }
  public boolean mouseover() {
    if (mouseX >= SZ+col*wid+2
      && mouseX <= SZ+col*wid+wid-4
      && mouseY >= row*hei+2
      && mouseY <= row*hei+hei-4) {
      return true;
    } else { return false; }
  }
}


class Pc {
  boolean on, exists;
  int cellNum;
  String name, user;
  int[] laston = {0,0,0,0,0,0};   // date Y-M-D h-m-s
  int[] lastReset = {0,0,0,0,0,0};   // date Y-M-D h-m-s

  Pc() {
    cellNum = -1;
  }

  public void setLastOn(){
    laston[0] = year();
    laston[1] = month();
    laston[2] = day();
    laston[3] = hour();
    laston[4] = minute();
    laston[5] = second();
  }
}


// controls() {
// }
public int timeSec(int[] moment){
  int t = moment[3]*3600+moment[4]*60+moment[5];
  return t;
}

public int timeNow(){
  int t = hour()*3600+minute()*60+second();
  return t;
}
/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here
 } //_CODE_:button1:12356:

 * Do not rename this tab!
 * =========================================================
 */

public void exists_checkbox_clicked(GCheckbox source, GEvent event) { //_CODE_:exists_checkbox:243290:

} //_CODE_:exists_checkbox:243290:

public void savebut_click(GButton source, GEvent event) { //_CODE_:savebut:534808:
  if ( selectedCell >= 0){
    // println(selectedCell + " - " + cells[selectedCell].pcID);
    if (cells[selectedCell].pcID <= 0 && exists_checkbox.isSelected()){
      for(int i = 0 ; i < pcs.length ; i++ ) {
        if (!pcs[i].exists){
          freeID = i;
          break;
        }
      }

      cells[selectedCell].pcID = freeID;
      pcs[cells[selectedCell].pcID].cellNum = selectedCell;
      println(cells[selectedCell].pcID);
    }
    pcs[cells[selectedCell].pcID].name = namefield.getText();
    pcs[cells[selectedCell].pcID].user = userfield.getText();
    pcs[cells[selectedCell].pcID].exists = cells[selectedCell].isPc = exists_checkbox.isSelected();

  }
  if (!exists_checkbox.isSelected()) {
    pcs[cells[selectedCell].pcID].exists = false;
    pcs[cells[selectedCell].pcID].cellNum = -1;
    cells[selectedCell].pcID = -1;
  }
  cells[selectedCell].selected = false;
  // selectedCell = -1;
  // println("-------------------");
    for(int i = 0 ; i < pcs.length ; i++ ) {
      println(pcs[i].cellNum);
    }
} //_CODE_:savebut:534808:

public void cancelbut_clicked(GButton source, GEvent event) { //_CODE_:cancelbut:774756:

} //_CODE_:cancelbut:774756:



// Create all the GUI controls.
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.ORANGE_SCHEME);
  G4P.setCursor(ARROW);
  surface.setTitle("Reset Monitor v0.0.2");
  namefield = new GTextField(this, 30, 30, 140, 30, G4P.SCROLLBARS_NONE);
  userfield = new GTextField(this, 30, 90, 140, 30, G4P.SCROLLBARS_NONE);
  exists_checkbox = new GCheckbox(this, 30, 140, 140, 30);
  savebut = new GButton(this, 30, 820, 60, 30);
  cancelbut = new GButton(this, 110, 820, 60, 30);
}

public void setgui(){
  namefield.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  namefield.setOpaque(true);
  namefield.setText(null);
  namefield.setPromptText("Hostname");
  userfield.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  userfield.setOpaque(true);
  userfield.setText(null);
  userfield.setPromptText("Username");
  exists_checkbox.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  exists_checkbox.setText("PC HERE");
  exists_checkbox.setTextBold();
  exists_checkbox.setOpaque(false);
  exists_checkbox.addEventHandler(this, "exists_checkbox_clicked");
  savebut.setText("SAVE");
  savebut.setTextBold();
  savebut.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  savebut.addEventHandler(this, "savebut_click");
  cancelbut.setText("CANCEL");
  cancelbut.setTextBold();
  cancelbut.setLocalColorScheme(GCScheme.ORANGE_SCHEME);
  cancelbut.addEventHandler(this, "cancelbut_clicked");
}

// Variable declarations
// autogenerated do not edit
GTextField namefield;
GTextField userfield;
GCheckbox exists_checkbox;
GButton savebut;
GButton cancelbut;
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
