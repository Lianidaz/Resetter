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

  void setLastOn(){
    laston[0] = year();
    laston[1] = month();
    laston[2] = day();
    laston[3] = hour();
    laston[4] = minute();
    laston[5] = second();
  }
}

int timeSec(int[] moment){
  int t = moment[3]*3600+moment[4]*60+moment[5];
  return t;
}

int timeNow(){
  int t = hour()*3600+minute()*60+second();
  return t;
}
