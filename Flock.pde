class Flock {
  // The Flock (a list of Particle objects)
  //This class connects particles with forces
  //puts constraints on the position, 
  //and displays the particles
  Default_Field default_field;
  Field field;
  ArrayList<Particle> particles; // An ArrayList for all the particles

  private final float[] influx;
  private final float[] time_diffs;
  private int counter;
  final int box_size;
  final int box_resolution;
  final PVector offset;
  final int inital_flock_size;
  final int field_change_rate;
  final float max_time_diff;

  Flock(float[][] data, PVector offset, int box_size, float max_supply) {
    this.particles = new ArrayList<Particle>(); // Initialize the ArrayList
    this.box_size= box_size;
    this.box_resolution = 50;
    this.offset = offset;
    this.influx = new float[data.length];
    this.time_diffs = new float[data.length];
    this.inital_flock_size = 1250;
    this.counter =0;
    this.field_change_rate =1;

    //create all the particles
    for (int i = 0; i < inital_flock_size; i++) {
      this.particles.add(new Particle(box_size));
    }
    //load the data in
    for (int i = 0; i < data.length; i++) {
      this.influx[i]= data[i][0];
    };
    for (int i = 0; i < data.length; i++) {
      this.time_diffs[i]= data[i][1];
    };
    this.max_time_diff = max(time_diffs);
    //println(time_diffs[9]);

    // create the default_field
    this.default_field = new Default_Field();
    // creates Field object
    this.field = new Field(influx, time_diffs, max_supply);
  }

  ////////////////////////////////////////////////////////////////////////////
  void run() {
    for (Particle a : particles) {
    acc_flowfield(this.default_field, a);
    acc_circulation(this.field, a);
    acc_radialSpring(this.field, a);

    a.update(); 
    borders(a);
    }
    display();
    counter += 1;
    if (counter%field_change_rate == 0){
      field_update();
    }
  }

  void acc_circulation(Field field, Particle a){
    int i = floor(map(a.position.x,-box_size,box_size,-box_resolution,box_resolution));
    int j = floor(map(a.position.y,-box_size,box_size,-box_resolution, box_resolution));
    PVector vec = field.circ_field(i,j);
    a.acceleration.add(vec);
  }
  void acc_radialSpring(Field field, Particle a){
    int i = floor(map(a.position.x,-box_size,box_size,-box_resolution,box_resolution));
    int j = floor(map(a.position.y,-box_size,box_size,-box_resolution, box_resolution));
    int k = floor(map(a.position.z,-box_size,box_size,-box_resolution, box_resolution));
    PVector vec = field.radialSpring(i,j,k);
    a.acceleration.add(vec);
  }

  void acc_flowfield(Default_Field default_field, Particle b){
    // Assumptions: borders() needs to be called after every iteration for valid map
    int i = floor(map(b.position.x,-box_size,box_size,0,default_field.box_resolution-1));
    int j = floor(map(b.position.y,-box_size,box_size,0, default_field.box_resolution-1));
    int k = floor(map(b.position.z,-box_size,box_size,0, default_field.box_resolution-1));
    //println(i);
    //println(j);
    b.acceleration = default_field.field[i][j][k];
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
  void field_update(){
    if (field.hasInflux()){
      field.nextValues();
    }
    else {
      field.influx_iterator = new Iterator(influx);
      field.time_diffs_iterator= new Iterator(time_diffs);
      field.nextValues();
    }
  }
}
