
import ddf.minim.effects.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

PGraphics partition;
int period = 100;
int n_tones = 12*8;
ArrayList<ArrayList<Note>> lut = new ArrayList<ArrayList<Note>>(period);
void setup()
{  
  partition = createGraphics(600,400);
  partition.beginDraw();
  partition.colorMode(RGB,1);
  partition.ellipseMode(CENTER);
  partition.endDraw();

  scale_x = partition.width/float(period);
  scale_y = partition.height/float(n_tones);
  
  size(200+partition.width, partition.height);
  frameRate(24);
  colorMode(RGB,1);
  
  minim = new Minim(this);
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  for (int i=0; i<period;++i){
    lut.add( new ArrayList<Note>() );
  }
}

float scale_x=1;
float scale_y=1;
void draw(){
  int time_index = frameCount%period;
  
  partition.beginDraw();
  partition.background(0.9);
  partition.stroke(0.5, 0.2);
  for( int i=0; i<5; ++i)
    for( float j=0; j<1; j+=pow(2,-i))
      partition.line( j*partition.width, 0, j*partition.width, partition.height );
  float x = ( time_index )*scale_x;
  partition.stroke(1,0,0);
  partition.line( x, 0, x, partition.height );
  for (ArrayList<Note> notes: lut )
    for (Note note: notes )
      note.draw();
  partition.endDraw();
  

  
  background(0.2);
  image(partition, 200, 0);
  fill(0,0.1);
  rect(200+int((mouseX-200)/scale_x)*scale_x,0,scale_x,height);
  rect(0,int((mouseY)/scale_y)*scale_y,width,scale_y);
  
  for (Note note: lut.get(time_index) )
    note.play();
}

