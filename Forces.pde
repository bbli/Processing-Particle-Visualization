
////////////////////////////////////////////////////////////////////////////

////////////////////
// A method that calculates and applies a steering force towards a target
// STEER = DESIRED MINUS VELOCITY
PVector seek(PVector target, Particle a) {
  PVector desired = PVector.sub(target, a.position);  // A vector pointing from the position to the target
  // Scale to maximum speed
  desired.normalize();
  desired.mult(a.maxspeed);
  // Steering = Desired minus Velocity
  PVector steer = PVector.sub(desired, a.velocity);
  steer.limit(a.maxforce);  // Limit to maximum steering force
  return steer;
}

// Cohesion
// For the average position (i.e. center) of all nearby particles, calculate steering vector towards that position
PVector cohesion (ArrayList<Particle> particles, Particle a){
  float neighbordist = 50;
  PVector sum = new PVector(0, 0, 0);   // Start with empty vector to accumulate all positions
  int count = 0;
  for (Particle other : particles) {
    float d = PVector.dist(a.position, other.position);
    if ((d > 0) && (d < neighbordist)) {
      sum.add(other.position); // Add position
      count++;
    }
  }
  if (count > 0) {
    sum.div(count);
    return seek(sum,a);  // Steer towards the position
  } 
  else {
    return new PVector(0, 0, 0);
  }
}
////////////////////

// Separation
// Method checks for nearby particles and steers away
PVector separate (ArrayList<Particle> particles, Particle a) {
  float desiredseparation = 25.0f;
  PVector steer = new PVector(0, 0, 0);
  int count = 0;
  // For every boid in the system, check if it's too close
  for (Particle other : particles) {
    float d = PVector.dist(a.position, other.position);
    // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
    if ((d > 0) && (d < desiredseparation)) {
      // Calculate vector pointing away from neighbor
      PVector diff = PVector.sub(a.position, other.position);
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
    steer.mult(a.maxspeed);
    steer.sub(a.velocity);
    steer.limit(a.maxforce);
  }
  return steer;
}

// Alignment
// For every nearby boid in the system, calculate the average velocity
PVector align (ArrayList<Particle> particles, Particle a) {
  float neighbordist = 50;
  PVector sum = new PVector(0, 0,0);
  int count = 0;
  for (Particle other : particles) {
    float d = PVector.dist(a.position, other.position);
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
    sum.mult(a.maxspeed);
    PVector steer = PVector.sub(sum, a.velocity);
    steer.limit(a.maxforce);
    return steer;
  } 
  else {
    return new PVector(0, 0, 0);
  }
}

