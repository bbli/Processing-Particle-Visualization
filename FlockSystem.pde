class FlockSystem {
  //This class controls placements of Flocks
  ArrayList<Flock> flocksystem;

  final int box_size;//Needs to be defined here so I can create appropiate offset
  final int number_of_titles;
  private int counter;


  FlockSystem(int number_of_titles, Table table){
    flocksystem = new ArrayList<Flock>();
    this.box_size = 400;
    this.number_of_titles = number_of_titles;
    this.counter = 0;

    // creates the flocks with respective data loaded in
    for (int i = 0; i < this.number_of_titles; i++) {
      PVector offset=indexToOffset(i,box_size);
      ////////////////////
      int rows=table.getRowCount();
      float[][] data = dataFromTable(i,table);
      ////////////////////
      flocksystem.add(new Flock(data, offset, box_size, g_max_supplies[i],i));
    }; 
  }

  ////////////////////////////////////////////////////////////////////////////
  void run(){
    for(Flock f: flocksystem){
      f.run();
    }
    counter += 1;
    if(counter>4500) counter=0;
    displayTime();
    displayTitles();
  }
  void displayTime(){
    textFont(newFont);
    textAlign(CENTER, CENTER);
    textSize(120);
    fill(0);
    float count = float(counter);
    float years = 2006+floor(count/365);

    float remainder = count/365-floor(count/365);
    float months = floor(map(remainder,0,1,1,13));
    String s = nf(years, 2,0);
    String t = nf(months, 2,0);
    text("Years: "+ s+" Months: "+t, 0,-1000,-500);
  }

  void displayTitles(){
    textFont(newFont);
    textAlign(CENTER, CENTER);
    textSize(80);
    fill(0);
    cam.beginHUD();
    text("Acceleration Field Representation of Data",width/2,height-100);
    cam.endHUD();

  }
  ////////////////////////////////////////////////////////////////////////////
  void allOffsetZero(){
    for(Flock flock: flocksystem){
      flock.offset = new PVector(0,0,0);
    }
  }
  void resetOffset(){
    for (int i = 0; i < this.number_of_titles; i++) {
      PVector offset=indexToOffset(i,box_size);
      flocksystem.get(i).offset = offset;
    }  
  }
  ////////////////////////////////////////////////////////////////////////////
  void turnTitlesOn(){
    for (Flock flock:flocksystem){
      flock.title_show = true;
    }
  }
  void turnTitlesOff(){
  for (Flock flock:flocksystem){
    flock.title_show = false;
  }
}


}
//Utility Functions

PVector indexToOffset(int index, int offset_size){
  PVector x = new PVector(0,0,0);
  // positive x goes to right
  // positive y goes down
  if (index == 0) x.add(new PVector(offset_size,-offset_size,0));
  else if (index == 1) x.add(new PVector(-offset_size,-offset_size,0));
  else if (index == 2) x.add(new PVector(-offset_size,offset_size,0));
  else if (index == 3) x.add(new PVector(offset_size,offset_size,0));
  return x;
}
float[][] dataFromTable(int index,Table table){
  float[][] data = new float[table.getRowCount()][2];
  for(int i =0; i< table.getRowCount(); i++){
    for(int j = 0; j< 2 ; j++){
      data[i][j] = table.getFloat(i,2*index+j);
    }
  }
  return data;
}
