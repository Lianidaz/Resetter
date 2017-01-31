int clicked() {
  for (int i = 0 ; i < gridX*gridY ; i++){
    if (cells[i].clicked(mouseX,mouseY)) {
      return i;
    }
  }
}
