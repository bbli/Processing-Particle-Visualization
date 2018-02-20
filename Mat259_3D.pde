
import peasy.*;
PeasyCam cam;

Flock flock;

void setup() {
  size(1200, 800,P3D);
  cam = new PeasyCam(this, 1200);
  cam.setFreeRotationMode();
  PVector offset = new PVector(200,0,0);
  flock = new Flock(offset);
  int inital_flock_size= 100;
  // Add an initial set of particles into the system
  for (int i = 0; i < inital_flock_size; i++) {
    flock.addParticle(new Particle(0,0,0, flock.box_size));
  }
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



