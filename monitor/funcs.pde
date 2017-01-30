int timeSec(int[] moment){
  int t = moment[3]*3600+moment[4]*60+moment[5];
  return t;
}

int timeNow(){
  int t = hour()*3600+minute()*60+second();
  return t;
}

void  canvas() {
  stroke(11);
  for (int i = 0 ; i <= width/WIDTH ; i++) {
    text(i,(i*WIDTH-WIDTH/2),HEIGHT/2);
    for (int j = 0 ; j < height/HEIGHT; j++ ) {
      line(i*WIDTH,0,i*WIDTH,height);
      line(0,j*HEIGHT,width,j*HEIGHT);
    }
  }
}
