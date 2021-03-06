import peasy.*;
import controlP5.*;
ControlP5 cp5;
PeasyCam cam;
FlockSystem system;
Default_Field flow_field;
float[] g_max_supplies;
int g_max_supply;
int g_min_time_diff;
int g_max_time_diff;
String[] g_titles;
int original_zoom;
int rate;
PImage wallpaper;
PFont newFont;


void setup() {
  size(1920, 1080,P3D);
  /////////////////////GUI/CAMERA////////////////////////
  //// Variables/Arrays: 
  //// Objects: 
  //// Effects: 
  
  rate=60;
  original_zoom =2400;
  cam = new PeasyCam(this, 0,0,0,original_zoom);
  //cam.setFreeRotationMode();
  cam.setYawRotationMode(); 
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(3000); 

  newFont = createFont("Futura_Bold.ttf",32);
  ControlFont f = new ControlFont(newFont, 24);
  cp5 = new ControlP5(this);
  int shift = 125;
  cp5.addButton("Programming", 1, width/2-500-shift, 0, 250, 40).setId(1).setFont(f).setColorBackground(color(192,192,192)).setColorCaptionLabel(0);
  cp5.addButton("Networking", 1, width/2-250-shift, 0, 250, 40).setId(2).setFont(f).setColorBackground(color(192,192,192)).setColorCaptionLabel(0);
  cp5.addButton("AI", 1, width/2-shift, 0, 250, 40).setId(3).setFont(f).setColorBackground(color(192,192,192)).setColorCaptionLabel(0);
  cp5.addButton("Software", 1, width/2+250-shift, 0, 250, 40).setId(4).setFont(f).setColorBackground(color(192,192,192)).setColorCaptionLabel(0);
  cp5.addButton("All", 1, width/2+500-shift, 0, 250, 40).setId(5).setFont(f).setColorBackground(color(192,192,192)).setColorCaptionLabel(0);

  cp5.addButton("Reset",1, 100,height/2-60,120,120).setId(6).setFont(f).setColorBackground(color(192,192,192)).setColorCaptionLabel(0);

  /////////////////////DATA LOADING////////////////////////
  //// Variables/Arrays: 
  //// Objects: 
  //// Effects: 
  
  Table table;
  int numCols;
  int number_of_titles;
  table = loadTable("dataset.csv");
  numCols = table.getColumnCount();
  println("Columns: " + numCols);
  number_of_titles = numCols/2;
  println(number_of_titles);
  g_max_supply =1002;
  g_min_time_diff =1;
  g_max_time_diff = 89;
  g_titles = new String[]{"Programming", "Networking", "AI", "Software"};
  g_max_supplies = new float[]{1002,164,219,634};

  system = new FlockSystem(number_of_titles, table);
  ////////////////////////////////////////////////////////////////////////////
  //wallpaper = loadImage("background3.png");
  frameRate(40);
}

void draw() {
  //frameRate(rate);
  background(10,105,173);
  //background(wallpaper);
  lights();
  system.run();
  //flock.run();
  //println(frameRate);
  gui();
  //drawFrameRate();
}

void gui() {
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  //cp5.draw();
  cp5.setAutoDraw(false);
  //ButtonBar b = cp5.addButtonBar("bar").setPosition(0,0).setSize(400,100).addItems(split("Programming Networking A.I Software All", " "));
  cp5.draw();
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

//void drawFrameRate(){
  //textAlign(CENTER, CENTER);
  //textSize(60);
  //fill(255,255,255,150);
  //text("FrameRate:"+rate, 0,700,750);
//}

////////////////////////////////////////////////////////////////////////////
void Programming(){
    for (Flock f: system.flocksystem){
      f.show = false;
    }
    system.flocksystem.get(0).show = true;
    system.allOffsetZero();
    system.turnTitlesOn();
    cam.lookAt(0,0,-2*system.box_size);
}
void Networking(){
    for (Flock f: system.flocksystem){
      f.show = false;
    }
    system.flocksystem.get(1).show = true;
    system.allOffsetZero();
    system.turnTitlesOn();
    cam.lookAt(0,0,-2*system.box_size);
}
void AI(){
    for (Flock f: system.flocksystem){
      f.show = false;
    }
    system.flocksystem.get(2).show = true;
    system.allOffsetZero();
    system.turnTitlesOn();
    cam.lookAt(0,0,-2*system.box_size);
}
void Software(){
    for (Flock f: system.flocksystem){
      f.show = false;
    }
    system.flocksystem.get(3).show = true;
    system.allOffsetZero();
    system.turnTitlesOn();
    cam.lookAt(0,0,-2*system.box_size);
}
void All(){
    for (Flock f: system.flocksystem){
      f.show = true;
    }
    system.allOffsetZero();
    system.turnTitlesOff();
    cam.lookAt(0,0,-2*system.box_size);
}
void Reset(){
  for (Flock f: system.flocksystem){
    f.show = true;
  }
  system.resetOffset();
  system.turnTitlesOn();
  cam.reset();
  println(cam.getState());
}

//void keyPressed(){
  //if(keyCode==RIGHT){
    //if (rate<60)rate += 2;
  //}
  //if(keyCode==LEFT){
   //if (rate>20) rate -= 2;
  //}
//}
