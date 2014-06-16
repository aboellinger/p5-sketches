
int n_particles = 100;
PVector[] position;
PVector[] velocity;
float[] mass;
float mouse_mass = 100;
float delta_time = 0.1;
void setup(){
  size(500,500);
  colorMode(RGB,1);
  position = new PVector[n_particles];
  velocity = new PVector[n_particles];
  mass = new float[n_particles];
  
  for (int i=0; i<n_particles; ++i){
    position[i] = new PVector(random(0, width),random(0, height));
    velocity[i] = new PVector(random(-10,10),random(-10,10));
    mass[i] = random(1,100);
  }
  
  background(0.2);
}

void draw(){
  noStroke();
  fill(0.2, 0.1);
  rect(0,0,width,height);
  
  stroke(0.8);
  PVector mpos = new PVector(mouseX, mouseY);
  for (int i=0; i<n_particles; ++i){
    PVector pos = position[i];
    PVector vel = velocity[i];
    PVector ppos = pos;
    
    PVector acc = PVector.sub(mpos, pos);
    float r = acc.mag();
    acc.setMag( delta_time * mouse_mass * mass[i] / pow( r, 2 ) );

    vel.add( acc );
    pos.add( PVector.mult( vel, delta_time ) );
    
    
    line(pos.x, pos.y, ppos.x, ppos.y);
  }
  
  println(mpos);
}
