
import ddf.minim.effects.*;

import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

void setup()
{
  size(512, 200, P3D);
  
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  out = minim.getLineOut();
  
  // given start time, duration, and frequency
  //out.playNote( 0.0, 0.9, 97.99 );
  //out.playNote( 1.0, 0.9, 123.47 );
  
  //for (int i=1; i<200; ++i){
  //  out.playNote(i*0.05,0.15,i+90);
  //}
}

int period = 8;
//boolean[] rythm = new boolean[]{true,true,
//                                true,false,
//                                true,false,
//                                true,false};
boolean[] rythm = new boolean[]{true,false,false,true,
                                true,true,false,true,
                                true,true,false,true,
                                true,false,true,false};
void draw(){
  if ( (frameCount%period) == 0){
    int f = frameCount/period;
    if ( rythm[f%rythm.length ]){
      out.playNote(0,mouseX*0.01,mouseY+10);
    }
  }
}


