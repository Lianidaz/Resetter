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
