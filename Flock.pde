class Flock {
  // The Flock (a list of Particle objects)
  //This class connects particles with forces
  //puts constraints on the position, 
  //and displays the particles
  Default_Field default_field;
  Field field;
  ArrayList<Particle> particles; // An ArrayList for all the particles
  PVector offset;

  final PImage colorBar;
  private final float[] influx;
  private final float[] time_diffs;
  private int counter;
  final int box_size;
  final int box_resolution;
  final int inital_flock_size;
  final float max_time_diff;
  boolean show;
  boolean title_show;
  final int index;
  final String title;

  Flock(float[][] data, PVector offset, int box_size, float max_supply, int index) {
    //Although offset is passed as reference, we don't need to worry because
    //it was created locally in FlockSystem, so nothing else can change it
    this.particles = new ArrayList<Particle>(); // Initialize the ArrayList
    this.box_size= box_size;
    this.box_resolution = 50;
    this.offset = offset;
    this.influx = new float[data.length];
    this.time_diffs = new float[data.length];
    this.inital_flock_size = 1250;
    this.counter =0;
    this.colorBar = loadImage("plasma.png");
    this.show = true;
    this.title_show = true;
    this.index = index;
    this.title = g_titles[index];

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
    display(field);
    counter += 1;
    field_update();
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

  void acc_flowfield(Default_Field default_field, Particle a){
    // Assumptions: borders() needs to be called after every iteration for valid map
    int i = floor(map(a.position.x,-box_size,box_size,0,default_field.box_resolution-1));
    int j = floor(map(a.position.y,-box_size,box_size,0, default_field.box_resolution-1));
    int k = floor(map(a.position.z,-box_size,box_size,0, default_field.box_resolution-1));
    //println(i);
    //println(j);
    a.acceleration = default_field.field[i][j][k];
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


  void display(Field field){
    //draw the enclosing box
    if (show){
    displayBox(offset, box_size);
    displayTitle(offset, box_size,title);
    displayParticles(offset, particles);
    }
  }
  void displayBox(PVector offset, int box_size){
    stroke(255,255,255);
    strokeWeight(3);
    noFill();
    pushMatrix();
    translate(offset.x, offset.y, offset.z);
    box(2*box_size);
    popMatrix();
  }

  void displayTitle(PVector offset, int box_size, String title){
    if (title_show){
      PVector further_offset=indexToOffset(index,box_size);
      PVector temp_offset = offset.copy();
      temp_offset.add(new PVector(3*further_offset.x,0,0));
      textAlign(CENTER, CENTER);
      textSize(100);
      fill(255,255,255);
      text(title,temp_offset.x, temp_offset.y, -500);
    }
  }

  void displayParticles(PVector offset, ArrayList<Particle> particles){
    color c = colorBar.get((int)map(field.circulating_level, field.min_circulating_level,field.max_circulating_level, 5, colorBar.width-5), colorBar.height/2);

    for (Particle a: particles){
      //fill(200, 100);
      //stroke(255,90);
      stroke(c);
      strokeWeight(3);
      pushMatrix();
      translate(offset.x, offset.y, offset.z);
      translate(a.position.x, a.position.y, a.position.z);
      point(0,0,0);
      //box(10);
      popMatrix();
    }
  }

  ////////////////////////////////////////////////////////////////////////////
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
