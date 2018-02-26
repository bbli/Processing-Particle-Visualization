class Iterator {
  float[] array;
  int max_length;
  int counter;

  Iterator(float[] array){
    this.array = array;
    this.max_length = array.length;
    this.counter =0;
  }
  boolean hasNext(){
    if (counter<max_length) return true;
    else return false;
  }
  float next(){
    counter += 1;
    return array[counter-1];
  }
}
