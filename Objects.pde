
// The Flock (a list of Particle objects)
class Flock {
  ArrayList<Particle> particles; // An ArrayList for all the particles
  int box_size;

  Flock(int new_box_size) {
    particles = new ArrayList<Particle>(); // Initialize the ArrayList
    box_size=new_box_size;
  }

  void run() {
    for (Particle b : particles) {
      b.run(particles);  // Passing the entire list of particles to each boid individually
    }
    stroke(255,255,255);
    strokeWeight(3);
    noFill();
    box(2*box_size);
  }

  void addParticle(Particle b) {
    particles.add(b);
  }

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
    acc__flockForces(particles,position);
    pos_vel__update();
    borders();
    render(position);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  ////////////////////////////////////////////////////////////////////////////

  ////////////////////
  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby particles, calculate steering vector towards that position
  PVector cohesion (ArrayList<Particle> particles, PVector position) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Particle other : particles) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0, 0);
    }
  }
  ////////////////////

  // Separation
  // Method checks for nearby particles and steers away
  PVector separate (ArrayList<Particle> particles, PVector position) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Particle other : particles) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }
    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Particle> particles, PVector position) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0,0);
    int count = 0;
    for (Particle other : particles) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0, 0);
    }
  }


  void acc__flockForces(ArrayList<Particle> particles, PVector position) {
    PVector sep = separate(particles, position);   // Separation
    PVector ali = align(particles, position);      // Alignment
    PVector coh = cohesion(particles, position);   // Cohesion
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



}


