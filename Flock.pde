//import java.util.Iterator;
// The Flock (a list of Particle objects)
class Flock {
  ArrayList<Particle> particles; // An ArrayList for all the particles
  int box_size;
  PVector offset;
  float maxspeed;
  float[] influx;
  float[] time_diffs;
  int inital_flock_size;

  Flock(float[][] data, PVector offset, int box_size) {
    this.particles = new ArrayList<Particle>(); // Initialize the ArrayList
    this.box_size= box_size;
    this.offset = offset;
    this.maxspeed = 10;
    this.influx = new float[data.length];
    this.time_diffs = new float[data.length];
    this.inital_flock_size = 2000;

    //create all the particles
    for (int i = 0; i < inital_flock_size; i++) {
      particles.add(new Particle(random(-this.box_size,this.box_size),random(-this.box_size,this.box_size),random(-this.box_size,this.box_size)));
    }
    //load the data in
    for (int i = 0; i < data.length; i++) {
      influx[i]= data[i][0];
    };
    for (int i = 0; i < data.length; i++) {
      time_diffs[i]= data[i][1];
    };
    //println(time_diffs[9]);
  }

  ////////////////////////////////////////////////////////////////////////////
  void run() {
    for (Particle a : particles) {
      acc_flowfield(flow_field, a);
      a.update();  // Passing the entire list of particles to each boid individually
      constrainSpeed(a);
      borders(a);
    }
    display();
    //removeParticles();
  }

  void acc_flowfield(Flow_Field flow_field, Particle b){
    // Assumptions: borders() needs to be called after every iteration for valid map
    int i = floor(map(b.position.x,-box_size,box_size,0,flow_field.box_resolution-1));
    int j = floor(map(b.position.y,-box_size,box_size,0, flow_field.box_resolution-1));
    int k = floor(map(b.position.z,-box_size,box_size,0, flow_field.box_resolution-1));
    //println(i);
    //println(j);
    b.acceleration = flow_field.field[i][j][k];
  }

  void borders(Particle a){
    //for (Particle a: particles){
      //if (a.position.x < -box_size) a.velocity.x = -a.velocity.x;
      //if (a.position.y < -box_size) a.velocity.y = -a.velocity.y;
      //if (a.position.z < -box_size) a.velocity.z = -a.velocity.z;
      //if (a.position.x > box_size) a.velocity.x = -a.velocity.x;
      //if (a.position.y > box_size) a.velocity.y = -a.velocity.y;
      //if (a.position.z > box_size) a.velocity.z = -a.velocity.z;

    //}
    if (a.position.x < -box_size) a.position.x = box_size;
    if (a.position.y < -box_size) a.position.y = box_size;
    if (a.position.z < -box_size) a.position.z = box_size;
    if (a.position.x > box_size) a.position.x = -box_size;
    if (a.position.y > box_size) a.position.y = -box_size;
    if (a.position.z > box_size) a.position.z = -box_size;

  }

  void constrainSpeed(Particle a){
    if (a.velocity.mag()>maxspeed) a.velocity.setMag(maxspeed);
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

      //fill(200, 100);
      stroke(255,90);
      strokeWeight(5);
      pushMatrix();
      translate(offset.x, offset.y, offset.z);
      translate(a.position.x, a.position.y, a.position.z);
      point(0,0,0);
      //box(10);
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

