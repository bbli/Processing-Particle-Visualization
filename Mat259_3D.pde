
import peasy.*;
PeasyCam cam;

Flock flock;

void setup() {
  size(1200, 800,P3D);
  cam = new PeasyCam(this, 500);
  cam.setFreeRotationMode();
  int box_size = 300;
  flock = new Flock(box_size);
  int inital_flock_size= 10;
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



