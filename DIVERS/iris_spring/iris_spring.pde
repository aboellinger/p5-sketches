


int nLine = 50;
int nSegm = 100;

void setup(){
  size(500, 500);
  colorMode(RGB, 1);
  squareDisposition(10,10,480,480);
}

void draw(){
  background(0.1);
  
  stroke(1);
  for( int k=0; k<spring.length; ++k){
    Spring s = spring[k];
    s.computeForce();
    if (s.breakable==true){
      float t = constrain(s.k, 0, 1);
      stroke(1-t,t,0,0.05);
    }else{
      stroke(1);
    }
    PVector p0 = position[s.i0];
    PVector p1 = position[s.i1];
    line(p0.x, p0.y, p1.x, p1.y);
  }
  
    for( int k=0; k<spring.length; ++k){
    spring[k].applyForce();
    }
    for( int k=0; k<spring.length; ++k){
    spring[k].breakConnections();
    }
  
//  noStroke();
//  for( int k=0; k<position.length; ++k){
//    PVector p = position[k];
//    ellipse(p.x, p.y,3,3);
//  }
  
}


PVector[] position;
boolean[] is_dynamic;
Spring[] spring;
void squareDisposition(float x, float y, float w, float h){
  position = new PVector[nLine*nSegm];
  for ( int i=0; i<nLine; ++i ){
    for ( int j=0; j<nSegm; ++j ){
      position[ i*nSegm + j ] = new PVector( x + w*i/(nLine-1), y + h*j/(nSegm-1) );
    } 
  }
  
  is_dynamic = new boolean[nLine*nSegm];
  spring = new Spring[4*(nLine-2)*(nSegm-2)];
  int k = 0;
  for ( int i=1; i<nLine-1; ++i ){
    for ( int j=1; j<nSegm-1; ++j ){
      is_dynamic[i*nSegm + j] = true;
      
      spring[k++] = new Spring(i*nSegm + j, i*nSegm + j-1, 1, 10, false);
      spring[k++] = new Spring(i*nSegm + j, i*nSegm + j+1, 1, 10, false);
      spring[k++] = (i==1)?
                    new Spring(i*nSegm + j, (i-1)*nSegm + j, w/(nLine), 100, false):
                    new Spring(i*nSegm + j, (i-1)*nSegm + j, 1, 10, true);       
      spring[k++] = (i==nLine-2)?
                    new Spring(i*nSegm + j, (i+1)*nSegm + j, w/(nLine), 100, false):
                    new Spring(i*nSegm + j, (i-1)*nSegm + j, 1, 10, true);
    }
  }
}

float delta = 0.001;
class Spring{
  int i0;
  int i1;
  float rest_length = 1.0;
  float k = 1.0;
  boolean breakable = false;
  float initial_length;
  
  PVector f = new PVector();
  
  
  Spring( int i0,  int i1, float rest_length, float k, boolean breakable ){
    this.i0 = i0;
    this.i1 = i1;
    this.rest_length = rest_length;
    this.k = k;
    this.breakable = breakable;
    
    initial_length = PVector.sub(position[i1],position[i0]).mag();
  }
  
  
  void computeForce(){
    f = PVector.sub(position[i1],position[i0]);
    float elongate = ( f.mag() - rest_length );   
    
    f.setMag( elongate * k * delta );
  }

  void applyForce(){
    if (is_dynamic[i0]) position[i0].add(f);
    if (is_dynamic[i1]) position[i1].sub(f);
  }
  
  
  void breakConnections(){
    float elongate = ( PVector.sub(position[i1],position[i0]).mag() - rest_length );   
    
   if( breakable && ( random(1) > 0.9999 || random(0.9*elongate/initial_length) > 1) ) k=0.0;
    //if( breakable && ( random(1) > 0.999 ) ) k=0.0;
    if ( k<0.00001 ) return; 
  }
}


