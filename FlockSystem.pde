class FlockSystem {
  //This class controls placements of Flocks
  ArrayList<Flock> flocksystem;

  private PVector offset;
  final int box_size;//Needs to be defined here so I can create appropiate offset
  final int number_of_titles;

  FlockSystem(int number_of_titles, Table table, float[] max_supplies){
    flocksystem = new ArrayList<Flock>();
    this.box_size = 400;
    this.number_of_titles = number_of_titles;

    // creates the flocks with respective data loaded in
    for (int i = 0; i < this.number_of_titles; i++) {
      PVector offset=indexToOffset(i,box_size);
      ////////////////////
      int rows=table.getRowCount();
      float[][] data = dataFromTable(i,table);
      ////////////////////
      flocksystem.add(new Flock(data, offset, box_size, max_supplies[i]));
    }; 
  }
  PVector indexToOffset(int index, int offset_size){
    PVector x = new PVector(0,0,0);
    if (index == 0) x.add(new PVector(offset_size,offset_size,0));
    else if (index == 1) x.add(new PVector(-offset_size,offset_size,0));
    else if (index == 2) x.add(new PVector(-offset_size,-offset_size,0));
    else if (index == 3) x.add(new PVector(offset_size,-offset_size,0));
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
  ////////////////////////////////////////////////////////////////////////////
  void run(){
    for(Flock f: flocksystem){
      f.run();
    }
  }
}


