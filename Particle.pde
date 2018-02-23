// The Particle class
class Particle {

  PVector position;
  PVector velocity;
  PVector acceleration;
  //float r;
  //float maxforce;    // Maximum steering force
  //float maxspeed;    // Maximum speed
  float box_size;
  float lifespan=5;

  Particle(float x, float y, float z, int box_size) {
    this.box_size= (float)box_size;
    acceleration = new PVector(0, 0,0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();
    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle), random(-0.2,0));

    position = new PVector(x, y, z);
    //r = 2.0;
    //maxspeed = 20;
    //maxforce = 0.3;
  }

////////////////////////////////////////////////////////////////////////////
  void update() {
    //acc__flockForces(particles);
    velocity.add(this.acceleration);
    // To get velocity out of 0 velocity zones. Also can make system look more chaotic
    //velocity.add(PVector.random3D().setMag(0.2));
    // Limit speed
    //velocity.limit(maxspeed);
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


  ////////////////////

////////////////////////////////////////////////////////////////////////////

  boolean isDead(){
    if ((int)lifespan>0) return false;
    else return true;
}

}
