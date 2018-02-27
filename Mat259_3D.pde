import peasy.*;
import controlP5.*;
ControlP5 cp5;
PeasyCam cam;
FlockSystem system;
Default_Field flow_field;
float[] max_supplies;
int g_max_supply;
int g_min_time_diff;
int g_max_time_diff;
String[] g_titles;


void setup() {
  size(1200, 800,P3D);
  frameRate(60);
  cam = new PeasyCam(this, 0,0,0,2400);
  //cam.setFreeRotationMode();
  cam.setYawRotationMode(); 
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(3000); 

  cp5 = new ControlP5(this);
  cp5.addButton("Programming", 1, 0, 0, 200, 40).setId(1);
  cp5.addButton("Networking", 1, 200, 0, 200, 40).setId(2);
  cp5.addButton("AI", 1, 400, 0, 200, 40).setId(3);
  cp5.addButton("Software", 1, 600, 0, 200, 40).setId(4);
  cp5.addButton("All", 1, 800, 0, 200, 40).setId(5);

  ////////////////////////////////////////////////////////////////////////////
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
  g_max_time_diff =149;
  g_titles = new String[]{"Programming", "Networking", "AI", "Software"};

  //These variables are defined inside the Field class
  //global_max_supply = 1002;
  //global_min_time_diff =1;
  //global_max_time_diff =149;
  max_supplies= new float[]{1002,164,219,634};
  system = new FlockSystem(number_of_titles, table, max_supplies);
  ////////////////////////////////////////////////////////////////////////////
}
void Programming(){
    for (Flock f: system.flocksystem){
      f.show = false;
    }
    system.flocksystem.get(0).show = true;
    system.allOffsetZero();
    cam.lookAt(0,0,-2*system.box_size);
}
void Networking(){
    for (Flock f: system.flocksystem){
      f.show = false;
    }
    system.flocksystem.get(1).show = true;
    system.allOffsetZero();
    cam.lookAt(0,0,-2*system.box_size);
}
void AI(){
    for (Flock f: system.flocksystem){
      f.show = false;
    }
    system.flocksystem.get(2).show = true;
    system.allOffsetZero();
    cam.lookAt(0,0,-2*system.box_size);
}
void Software(){
    for (Flock f: system.flocksystem){
      f.show = false;
    }
    system.flocksystem.get(3).show = true;
    system.allOffsetZero();
    cam.lookAt(0,0,-2*system.box_size);
}
void All(){
    for (Flock f: system.flocksystem){
      f.show = true;
    }
    system.allOffsetZero();
    cam.lookAt(0,0,-2*system.box_size);
}

void draw() {
  background(0);
  lights();
  system.run();
  //flock.run();
  //println(frameRate);
  gui();
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
