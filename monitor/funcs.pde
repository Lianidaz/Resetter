int timeSec(int[] moment){
  int t = moment[3]*3600+moment[4]*60+moment[5];
  return t;
}

int timeNow(){
  int t = hour()*3600+minute()*60+second();
  return t;
}

void  canvas(boolean grid) {
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

void writeJSON(int i){
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

int cellIsPc(int celli) {
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
