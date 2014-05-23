import java.lang.Integer;

float attractDist = 50;
float repulseDist = 25;

int nP = 100; // in pixel/s
float maxSpeed = 100;
PVector position[] = new PVector[nP];
PVector velocity[] = new PVector[nP];

int w = 512;
int h = 512;
int nw = min(50,(int)(w/attractDist)); // grid's width 
int nh = min(50,(int)(h/attractDist)); // grid's height 

float particlesPerCell[][] = new float[nw][nh];
ArrayList particlesInCell[][] = new ArrayList[nw][nh];

int previousTime;
float deltaTime;

void setup(){
  size(w,h);
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
  
  //deltaTime /= 5;
  
  updateParticles();
  
  // Draw Cells
  noStroke();
  for (float i=0; i<nw; ++i){
    for (float j=0; j<nh; ++j){
      fill(particlesPerCell[(int)i][(int)j]/15);
      rect(i*w/nw,j*h/nh,(i+1)*w/nw,(j+1)*h/nh);
    }
  }
  
  
  updateInteractions();
  
  // Draw Particles
  stroke(0.5);
  fill(1);
  for (int i=0; i<nP; ++i){
    line(int(position[i].x),int(position[i].y),int(position[i].x+velocity[i].x/10),int(position[i].y+velocity[i].y/10));
    ellipse(int(position[i].x),int(position[i].y),2,2);
  }
  
  

}

void initializeParticles(){
  float maxSpd = maxSpeed/sqrt(2);
  for (int i=0; i<nP; ++i){
    position[i] = new PVector(random(w), random(h));
    velocity[i] = new PVector(random(-maxSpd,maxSpd), random(-maxSpd,maxSpd));
  }
}

void updateParticles(){
  for (int i=0; i<nw; ++i){
    for (int j=0; j<nh; ++j){
      particlesPerCell[i][j]=0;
      particlesInCell[i][j]= new ArrayList();
    }
  }
  
  for (int i=0; i<nP; ++i){
    // Update position
    position[i].add(PVector.mult(velocity[i],deltaTime));
    if ((position[i].x<0 && velocity[i].x<0) || (position[i].x>w && velocity[i].x>0)){
      velocity[i].x *= -1;
    }
    if ((position[i].y<0 && velocity[i].y<0) || (position[i].y>h && velocity[i].y>0)){
      velocity[i].y *= -1;
    }
    
    // Position in grid
    if(position[i].x>=0 && position[i].x<w && position[i].y>=0 && position[i].y<h){ // Particle is in the grid
      int gi = int(position[i].x*nw/w);
      int gj = int(position[i].y*nh/h);
      particlesPerCell[gi][gj] += 1;
      particlesInCell[gi][gj].add(new Integer(i));
    }
  }
}

void updateInteractions(){
  // Grid is updated, we can compute interactions
  for(int gi=0; gi<nw; ++gi){
    for(int gj=0; gj<nh; ++gj){
      ArrayList particlesInteracting = new ArrayList();
      particlesInteracting.addAll(particlesInCell[gi][gj]);
      if(gi+1<nw){
        particlesInteracting.addAll(particlesInCell[gi+1][gj]);}
      if(gj+1<nh){
        particlesInteracting.addAll(particlesInCell[gi][gj+1]);}
      if((gi+1<nw)&&(gj+1<nh)){
        particlesInteracting.addAll(particlesInCell[gi+1][gj+1]);}
      //println(particlesInteracting.size());
      for(int k1=0;k1<particlesInteracting.size();++k1){
        for(int k2=k1+1;k2<particlesInteracting.size();++k2){
          int i1 = (Integer)particlesInteracting.get(k1);
          int i2 = (Integer)particlesInteracting.get(k2);
          
          PVector force = PVector.sub(position[i1],position[i2]);
          float d = force.mag();
          force.normalize();
          
          float intensity;
          if(d<attractDist){
           if(d<repulseDist){
             stroke(1,0,0);
             intensity = repulseIntensity(d)*deltaTime;
           }else{
             stroke(0,1,0);
             intensity = attractIntensity(d)*deltaTime;
           }
          
          velocity[i1].add(PVector.mult(force,-intensity));
          velocity[i2].add(PVector.mult(force,intensity));
           
          line(position[i1].x,position[i1].y,
               position[i2].x,position[i2].y);
           
          }
        }
      }
    }
  }
}

float sqRepulseDist = repulseDist*repulseDist;
float repulseIntensity(float d){
  return -sqRepulseDist/d + repulseDist;
}

float attractIntensity(float d){
  return -(d-repulseDist)*(d-attractDist);
}
