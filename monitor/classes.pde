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
  void show() {
    if (isPc) {
      if (pcs[pcID].on()){
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
  boolean mouseover() {
    if (mouseX >= SZ+col*wid+2
      && mouseX <= SZ+col*wid+wid-4
      && mouseY >= row*hei+2
      && mouseY <= row*hei+hei-4) {
      return true;
    } else { return false; }
  }
}


class Pc {
  boolean exists;
  int cellNum;
  String name, user;
  int[] laston = {0,0,0,0,0,0};   // date Y-M-D h-m-s
  int[] lastReset = {0,0,0,0,0,0};   // date Y-M-D h-m-s

  Pc() {
    cellNum = -1;
  }

  boolean on() {
    if (timeNow() - timeSec(laston) < 10) return true;
    else return false;
  }

  void setInfo(String msg) {
    if (msg.equals("1")) {
      setLastOn();
    }

  }

  void setLastOn(){
    laston[0] = year();
    laston[1] = month();
    laston[2] = day();
    laston[3] = hour();
    laston[4] = minute();
    laston[5] = second();
  }

}

class Mqttspy {
  String[] lines = new String[15];
  Mqttspy() {
    for (int i = 0 ; i < lines.length ; i++) {
      lines[i] = "";
    }
  }
  void show() {
    fill(255);
    stroke(0);
    strokeWeight(3);
    rect(30,200,140,291);
    fill(0);
    textSize(13);
    textAlign(LEFT);
    for (int i = 0 ; i< lines.length ; i++) {
      text(lines[i], 35, 218 + i*19);
    }
  }

  void update(String msg) {
    for (int i = lines.length-1 ; i > 0  ; i--) {
      lines[i] = lines [i-1];
    }
    lines[0] = msg;
  }
}
