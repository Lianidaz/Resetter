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

  void display(){
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

  void setLastOnline(){
    lastonline[0] = year();
    lastonline[1] = month();
    lastonline[2] = day();
    lastonline[3] = hour();
    lastonline[4] = minute();
    lastonline[5] = second();
  }

}
