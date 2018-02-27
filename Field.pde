class Field {
  //This class returns influx and time_diffs numbers
  //and in general handles the iterator aspects of 
  //the **influx** and **time_diffs** arrays
  private Iterator influx_iterator; 
  private Iterator time_diffs_iterator; 
  float circulating_level;
  final float min_circulating_level;
  final float max_circulating_level;
  float radial_level;
  private float average_time_diff;
  private float current_supply;

  final float global_min_time_diff;
  final float global_max_time_diff;
  final float global_max_supply;
  final int box_resolution;
  //final float max_supply;


  Field(float[] influx, float[] time_diffs, float max_supply){
    this.influx_iterator = new Iterator(influx);
    this.time_diffs_iterator = new Iterator(time_diffs);
    this.average_time_diff = influx[0];
    this.current_supply = max_supply;
    this.global_min_time_diff = 1;
    this.global_max_time_diff = 149;
    //this.max_supply = max_supply;
    this.global_max_supply = 1002;
    this.box_resolution =100;
    this.min_circulating_level = 20;
    this.max_circulating_level = 2000;
  }
  ////////////////////////////////////////////////////////////////////////////

  // FOr now, code assumes next is always called on
  // influx and time_diffs at the same time
  boolean hasInflux(){
    return influx_iterator.hasNext();
  }

  void nextValues(){
    float possible_influx=influx_iterator.next();
    float possible_time_diff = time_diffs_iterator.next();
    if (0 != possible_influx){
      average_time_diff = 0.5*average_time_diff + 0.5*possible_time_diff;
      current_supply = current_supply + possible_influx;
    }
    circulating_level = 1/map(average_time_diff, this.global_min_time_diff, global_max_time_diff,1/max_circulating_level,1/min_circulating_level);
    radial_level = sq(map(current_supply, 0, this.global_max_supply, 0,4));
    //if influx value is 0, return previous vector
    //println("circulating_level is now: "+ circulating_level);
    //println("radial_level is now: "+radial_level);

  }
  ////////////////////////////////////////////////////////////////////////////
  PVector circ_field(float i, float j){
    PVector vec = new PVector(-j,i);
    float r = vec.mag();
    vec.setMag(1/r);
    vec.mult(circulating_level);
    return vec;
  }
  PVector radialSpring(float i, float j, float k){
    PVector vec = new PVector(-i,-j,-k);
    vec.setMag(1/sqrt(vec.mag()));
    vec.mult(radial_level);
    return vec;
  }
  ////////////////////////////////////////////////////////////////////////////
}
