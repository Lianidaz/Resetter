void Jread() {
  Records = loadJSONArray("data/pcs.json");
  for (int i = 0 ; i < Records.size() ; i++) {
    JSONObject record = Records.getJSONObject(i);
    pcs[i].cellNum = record.getInt("cell");
    pcs[i].name = record.getString("name");
    pcs[i].user = record.getString("user");
    pcs[i].exists = record.getBoolean("exists");
    cells[pcs[i].cellNum].pcID = i;
    cells[pcs[i].cellNum].isPc = pcs[i].exists;
  }
}

void Jwrite(int id) {
  JSONObject record = new JSONObject();
  record.setInt("cell",pcs[id].cellNum);
  record.setBoolean("exists",pcs[id].exists);
  record.setString("name",pcs[id].name);
  record.setString("user",pcs[id].user);
  // record.setInt("lastrY",lastReset[0]);
  // record.setInt("lastrM",lastReset[1]);
  // record.setInt("lastrD",lastReset[2]);
  // record.setInt("lastrh",lastReset[3]);
  // record.setInt("lastrm",lastReset[4]);
  // record.setInt("lastrs",lastReset[5]);
  Records.setJSONObject(id, record);
  saveJSONArray(Records, "/data/PCs.json");
}

int timeSec(int[] moment){
  int t = moment[3]*3600+moment[4]*60+moment[5];
  return t;
}

int timeNow(){
  int t = hour()*3600+minute()*60+second();
  return t;
}