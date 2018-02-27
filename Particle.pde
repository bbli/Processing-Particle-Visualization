// The Particle class
class Particle {
  PVector velocity;
  PVector acceleration;
  private PVector position;

  final int box_size;
  final float maxspeed;    // Maximum speed

  Particle(int box_size) {
    this.box_size = box_size;
    position = new PVector(random(-this.box_size,this.box_size),random(-this.box_size,this.box_size),random(-this.box_size,this.box_size));
    velocity = PVector.random3D();
    acceleration = new PVector(0, 0,0);
    maxspeed = 30;
  }

////////////////////////////////////////////////////////////////////////////
  void update() {
    //acc__flockForces(particles);
    velocity.add(acceleration);
    // To get velocity out of 0 velocity zones. Also can make system look more chaotic
    //velocity.add(PVector.random3D().setMag(0.2));
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  ////////////////////
  //void applyForce(PVector force) {
    //// We could add mass here if we want A = F / M
    //acceleration.add(force);
  //}


  //void acc__flockForces(ArrayList<Particle> particles) {
    //PVector sep = separate(particles, this);   // Separation
    //PVector ali = align(particles, this);      // Alignment
    //PVector coh = cohesion(particles, this);   // Cohesion
    //// Arbitrarily weight these forces
    //sep.mult(1.5);
    //ali.mult(1.0);
    //coh.mult(1.0);
    //// Add the force vectors to acceleration
    //applyForce(sep);
    //applyForce(ali);
    //applyForce(coh);
  //}
  ////////////////////
////////////////////////////////////////////////////////////////////////////
  //boolean isDead(){
    //if ((int)lifespan>0) return false;
    //else return true;
//}

}
