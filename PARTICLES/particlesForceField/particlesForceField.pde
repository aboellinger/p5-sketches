int nP = 10000;
PVector[] position = new PVector[nP];
PVector[] velocity = new PVector[nP];
float maxSpeed = 1;

float[] potential = new float[nP];
float dynamicConserve = 0.9;
float repulseValue = 1000;

int w = 256;
int h = 256;


int previousTime;
float deltaTime;

void setup(){
  size(2*w,h);
  colorMode(RGB,1);
  previousTime = millis();
  deltaTime = 0;
  
 initializeParticles();
}

void draw(){
  background(0.1);
  deltaTime = float(millis()-previousTime)/1000;
  previousTime = millis();
  println("deltaTime = "+ deltaTime +" | fps = " + (1/deltaTime)+"\r");
   
  updateParticles();
   
  float[] data = new float[w*h];
  for (int i=0; i<nP; ++i){
    if((int)position[i].x<w && (int)position[i].y<h &&
      (int)position[i].x>0 && (int)position[i].y>0){
      data[(int)position[i].x+(int)position[i].y*w] += 1;
    }
  }
  PImage iPos = getImage(data,w,h);
  image(iPos,0,0);
  
  potential = gaussianBlur(data,w,h);
  PImage iPot = getImage(potential,w,h);
  image(iPot,w,0);
  
  float[] fx = getDx(potential,w,h);
  float[] fy = getDy(potential,w,h);
  for(int i=0; i<nP;++i){
   int x = floor(position[i].x);
   int y = floor(position[i].y);
   if(x<0) { x=0; }
   if(y<0) { y=0; }
   velocity[i].x += -fx[x+w*y]*deltaTime*repulseValue; 
   velocity[i].y += -fy[x+w*y]*deltaTime*repulseValue; 
  }
}

void initializeParticles(){
  float maxSpd = maxSpeed/sqrt(2);
  for (int i=0; i<nP; ++i){
    position[i] = new PVector(w/4+random(w/2), h/4+random(h/2));
    velocity[i] = new PVector(random(-maxSpd,maxSpd), random(-maxSpd,maxSpd));
  }
}

void updateParticles(){  
  for (int i=0; i<nP; ++i){
    // Update position
    velocity[i].mult(dynamicConserve);
    position[i].add(PVector.mult(velocity[i],deltaTime));
    if (position[i].x<0){
      position[i].x = 0;
      if(velocity[i].x<0) velocity[i].x *= -1;
    }
    if(position[i].x>=w){
     position[i].x = w-1;
     if(velocity[i].x>0) velocity[i].x *= -1;
    }
    if (position[i].y<0){
      position[i].y = 0;
      if(velocity[i].y<0) velocity[i].y *= -1;
    }
    if(position[i].y>=h){
     position[i].y = h-1;
     if(velocity[i].y>0) velocity[i].y *= -1;
    }
  }
}
