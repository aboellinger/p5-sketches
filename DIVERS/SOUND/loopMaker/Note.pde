class Note
{
  // time, duration, and frequency
  float x;
  float y;
  float r;
  float l;
  
  Note( float x, float y ){
    this.x = x; 
    this.y = y;
    this.r = 10;
    this.l = 1;
    
    lut.get( int(x/scale_x) ).add( this );
  }
  
  void play(){
    out.playNote(0, this.l, (partition.height-y)*10);
  }
  
  void draw(){
    partition.ellipse(x,y,r,r);
  }
}
