import peasy.*;
PeasyCam cam;
FlockSystem system;
Default_Field flow_field;
int global_max_supply;
int global_max_time_diff;
int global_min_time_diff;
float[] max_supplies;

void setup() {
  size(1200, 800,P3D);
  frameRate(30);
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


class Default_Field{
  // Create the vector field once
  // For now, we will just create in 2D, since 3D is just copies
  final int box_resolution= 100;
  PVector[][][] field= new PVector[box_resolution][box_resolution][box_resolution];
  private float radial_strength;
  private float circulation_strength;

  Default_Field(){
    for (int i = 0; i < box_resolution; i++) {
      for (int j = 0; j < box_resolution; j++) {
        for (int k = 0; k < box_resolution; k++) {
          field[i][j][k] = new PVector(0,0,0);
        };
      };
    };
    //createCirculatingField(circulation_level);
    //createRadialField(radial_level);
    createNoiseField(0.05,5);
    //ZXCirculatingField(10);
    //createUnitRadialField(2);
  }

  void createNoiseField(float level, float z_level){
    noiseSeed(20);
    //float zoff =0;
    //float noise_level=5;
    float noise_level=level;
    float inc = 0.1;
    float xoff =0;
    float z_frac =z_level;
    for (int i = 0; i < box_resolution; i++) {
      float yoff =0;
      for (int j = 0; j < box_resolution; j++) {
        float zoff = 0;
        float angle = noise(xoff, yoff )* TWO_PI;
        PVector v = PVector.fromAngle(angle);
        for (int k = 0; k < box_resolution; k++) {
          v.setMag(sqrt(sq(i-50)+sq(j-50)+sq(k-50)));
          v.mult(noise_level);
          //
          v.y = -v.y;
          field[i][box_resolution-j-1][k].add(v);
          //
          v.y = -v.y;
          v.z = z_frac*random(-1,1);
          //
          field[i][j][k].add(v);
          zoff += inc;
        };
        yoff += inc;
      };
      xoff += inc;
      //println(field[i][0][0]);
    };
  }
  void ZXCirculatingField(float level){
    float circulating_level=level;
    for (int i = 0; i < box_resolution; i++) {
      float xoff = float(i)-float(box_resolution/2);
      for (int j = 0; j < box_resolution; j++) {
        float yoff = float(j)-float(box_resolution/2);
        PVector vec = new PVector(-yoff,0,xoff);
        float r = vec.mag();
        vec.setMag(1);
        vec.mult(circulating_level);
        for (int k = 0; k < box_resolution; k++) {
          field[i][j][k].add(vec);
        };
      };
    };
  }
  void createUnitRadialField(float level){
    float radial_level=level;
    for (int i = 0; i < box_resolution; i++) {
      float xoff = float(i)-float(box_resolution/2);
      for (int j = 0; j < box_resolution; j++) {
        float yoff = float(j)-float(box_resolution/2);
        for (int k = 0; k < box_resolution; k++) {
          float zoff = float(k)-float(box_resolution/2);
          PVector vec = new PVector(-xoff,-yoff, -zoff);
          vec.setMag(1);
          vec.mult(radial_level);
          field[i][j][k].add(vec);
        };
      };
    };
  }

//void createRadialField(float level){
  //float radial_level=level;
    //for (int i = 0; i < box_resolution; i++) {
      //float xoff = float(i)-float(box_resolution/2);
      //for (int j = 0; j < box_resolution; j++) {
        //float yoff = float(j)-float(box_resolution/2);
        //for (int k = 0; k < box_resolution; k++) {
          //float zoff = float(k)-float(box_resolution/2);
          //field[i][j][k].add(vec);
        //};
      //};
    //};
}
