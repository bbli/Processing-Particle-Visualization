import peasy.*;
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
  cam = new PeasyCam(this, 0,0,0,2000);
  //cam.setFreeRotationMode();
  cam.setYawRotationMode(); 
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(3000); 
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
  g_titles = new String[]{"Programming", "Networking", "A.I", "Software"};

  //These variables are defined inside the Field class
  //global_max_supply = 1002;
  //global_min_time_diff =1;
  //global_max_time_diff =149;
  max_supplies= new float[]{1002,164,219,634};
  system = new FlockSystem(number_of_titles, table, max_supplies);
  ////////////////////////////////////////////////////////////////////////////
}

void keyPressed(){
  if (key == '1') {
    cam.lookAt(system.box_size, -system.box_size, -2*system.box_size);
    // show(1)
  }
  if (key == '2'){
    cam.lookAt(-system.box_size, -system.box_size, -2*system.box_size);
    //show(2)
  } 
  if (key == '3'){
    cam.lookAt(-system.box_size, system.box_size, -2*system.box_size);
    //show(3)
  } 
  if (key == '4'){
    cam.lookAt(system.box_size, system.box_size, -2*system.box_size);
    //show(4)
  }  
  else if (key == 'h'){
    cam.lookAt(0,0,0);
    //show all
  } 
}
void draw() {
  background(0);
  lights();
  system.run();
  //flock.run();
  //println(frameRate);
}


