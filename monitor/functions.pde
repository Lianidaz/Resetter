int timeSec(int[] moment){
  int t = moment[3]*3600+moment[4]*60+moment[5];
  return t;
}

int timeNow(){
  int t = hour()*3600+minute()*60+second();
  return t;
}
