//import java.util.Iterator;
// The Flock (a list of Particle objects)
class Flock {
  ArrayList<Particle> particles; // An ArrayList for all the particles
  int box_size;
  PVector offset;

  Flock(int box_size,PVector offset) {
    particles = new ArrayList<Particle>(); // Initialize the ArrayList
    this.box_size=box_size;
    this.offset = offset;
  }

  void addParticle(Particle b) {
    particles.add(b);
  }
  ////////////////////////////////////////////////////////////////////////////
  void run() {
    for (Particle b : particles) {
      b.update(particles);  // Passing the entire list of particles to each boid individually
    }
    borders();
    display();
    //removeParticles();
  }

  void borders(){
    for (Particle a: particles){
      if (a.position.x < -box_size) a.velocity.x = -a.velocity.x;
      if (a.position.y < -box_size) a.velocity.y = -a.velocity.y;
      if (a.position.z < -box_size) a.velocity.z = -a.velocity.z;
      if (a.position.x > box_size) a.velocity.x = -a.velocity.x;
      if (a.position.y > box_size) a.velocity.y = -a.velocity.y;
      if (a.position.z > box_size) a.velocity.z = -a.velocity.z;

    }
  }

  void display(){
    //draw the enclosing box
    stroke(255,255,255);
    strokeWeight(3);
    noFill();
    pushMatrix();
    translate(offset.x, offset.y, offset.z);
    box(2*box_size);
    popMatrix();

    for (Particle a: particles){

      fill(200, 100);
      stroke(255);
      strokeWeight(3);
      pushMatrix();
      translate(offset.x, offset.y, offset.z);
      translate(a.position.x, a.position.y, a.position.z);
      box(10);
      popMatrix();
    }
  }
  //void removeParticles(){
    //Iterator it = new Iterator(particles);
    //while(it.hasNext()){
      //Particle a = it.next();
      //if (a.isDead()) particles.remove();
    //}
  //}
////////////////////////////////////////////////////////////////////////////

}

// The Particle class
class Particle {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  float box_size;
  float lifespan=5;

  Particle(float x, float y, float z, int box_size) {
    this.box_size= (float)box_size;
    acceleration = new PVector(0, 0,0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle), random(-1,1));

    position = new PVector(x, y, z);
    r = 2.0;
    maxspeed = 20;
    maxforce = 0.3;
  }

////////////////////////////////////////////////////////////////////////////
  void update(ArrayList<Particle> particles) {
    acc__flockForces(particles);
    pos_vel__change();
    //borders();
    //render(position);
  }

  ////////////////////
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }


  void acc__flockForces(ArrayList<Particle> particles) {
    PVector sep = separate(particles, this);   // Separation
    PVector ali = align(particles, this);      // Alignment
    PVector coh = cohesion(particles, this);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
  ////////////////////

  void pos_vel__change() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }
////////////////////////////////////////////////////////////////////////////

  boolean isDead(){
    if ((int)lifespan>0) return false;
    else return true;
}

}
