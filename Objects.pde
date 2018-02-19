//import java.util.Iterator;
// The Flock (a list of Particle objects)
class Flock {
  ArrayList<Particle> particles; // An ArrayList for all the particles
  int box_size;

  Flock(int new_box_size) {
    particles = new ArrayList<Particle>(); // Initialize the ArrayList
    box_size=new_box_size;
  }

  void addParticle(Particle b) {
    particles.add(b);
  }
  ////////////////////////////////////////////////////////////////////////////
  void run() {
    for (Particle b : particles) {
      b.run(particles);  // Passing the entire list of particles to each boid individually
    }
    displaySystem();
    //removeParticles();
  }


  void displaySystem(){
    stroke(255,255,255);
    strokeWeight(3);
    noFill();
    box(2*box_size);
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

  Particle(float x, float y, float z, int new_box_size) {
    box_size= (float)new_box_size;
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

  void run(ArrayList<Particle> particles) {
    acc__flockForces(particles);
    pos_vel__update();
    borders();
    render(position);
  }

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
  ////////////////////////////////////////////////////////////////////////////

  void pos_vel__update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // Wraparound
  void borders() {
    if (position.x < -box_size) velocity.x = -velocity.x;
    if (position.y < -box_size) velocity.y = -velocity.y;
    if (position.z < -box_size) velocity.z = -velocity.z;
    if (position.x > box_size) velocity.x = -velocity.x;
    if (position.y > box_size) velocity.y = -velocity.y;
    if (position.z > box_size) velocity.z = -velocity.z;
  }

  void render(PVector position) {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(200, 100);
    stroke(255);
    strokeWeight(3);
    pushMatrix();
    translate(position.x, position.y, position.z);
    rotate(theta);
    box(10);
    popMatrix();
  }
  boolean isDead(){
    if ((int)lifespan>0) return false;
    else return true;
}

}
