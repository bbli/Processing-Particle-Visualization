
import peasy.*;
PeasyCam cam;
Flock flock;
Flow_Field flow_field;

void setup() {
  size(1200, 800,P3D);
  cam = new PeasyCam(this, 1200);
  cam.setFreeRotationMode();
  PVector offset = new PVector(200,0,0);
  flock = new Flock(offset);
  int inital_flock_size= 1000;
  // Add an initial set of particles into the system
  int box_size = 300;
  for (int i = 0; i < inital_flock_size; i++) {
    flock.addParticle(new Particle(random(-box_size,box_size),random(-box_size,box_size),0, flock.box_size));
  }
  //int box_size=300;
  flow_field = new Flow_Field();
  flow_field.createNoiseField();
  flow_field.createCirculatingField();
}

void draw() {
  background(0);
  //lights();
  flock.run();
}

//// Add a new boid into the System
//void mousePressed() {
  //flock.addParticle(new Particle(mouseX,mouseY));
//}


class Flow_Field{
  // Create the vector field once
  // For now, we will just create in 2D, since 3D is just copies
  int box_resolution;
  PVector[][][] field= new PVector[box_resolution][box_resolution][box_resolution];
  Flow_Field(){
    box_resolution= 100;
    for (PVector vec: field){
      vec = new PVector(0,0,0);
    }
  }

  void createNoiseField(){
    noiseSeed(10);
    //float zoff =0;
    float noise_level=5;
    float inc = 0.1;
    float xoff =0;
    for (int i = 0; i < box_resolution; i++) {
      float yoff =0;
      for (int j = 0; j < box_resolution; j++) {
        float zoff = 0;
        float angle = noise(xoff, yoff )* TWO_PI;
        PVector v = PVector.fromAngle(angle);
        for (int k = 0; k < box_resolution; k++) {
          v.z = noise(xoff, yoff, zoff);
          v.setMag(noise_level);
          field[i][j][k].add(v);
          zoff += inc;
        };
        yoff += inc;
      };
      xoff += inc;
      println(field[i][0][0]);
    };
  }
  void createCirculatingField(){
    float circulating_level=10;
    for (int i = 0; i < box_resolution; i++) {
      float xoff = float(i)-float(box_resolution/2);
      for (int j = 0; j < box_resolution; j++) {
        float yoff = float(j)-float(box_resolution/2);
        PVector vec = new PVector(i,j);
        float r = vec.mag();
        vec.setMag(1/r);
        vec.mult(circulating_level);
        for (int k = 0; k < box_resolution; k++) {
          field[i][j][k] = vec;
        };
      };
    };
  }
}
