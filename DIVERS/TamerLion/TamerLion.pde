

void moveLion(float speed){
  float sign = 1;
  if(lion.cross(tamer).z < 0)
    sign = -1;
  float d_theta = sign * lion_speed * speed;
  lion_theta += d_theta;
  
  lion_direction = d_theta;
  lion.x = cos(lion_theta);
  lion.y = sin(lion_theta);
}
float moveTamer(float dt){
  
  float r = tamer.mag();
  if (r>=1)
    return 0;
    
  PVector new_tamer = moveTamer_spiral(dt, r);
  
  float speed = sqrt(sq(tamer.x-new_tamer.x)+sq(tamer.y-new_tamer.y));
  
  tamer.x = new_tamer.x;
  tamer.y = new_tamer.y;
  
  
  return speed;
}
PVector moveTamer_spiral(float dt, float r){
  float x,y;
  
  //println("dt:"+dt);
  if ( r<0.01 )
    return PVector.add(tamer,new PVector(dt,0));
  
  if (r>0.25)
    run = true;
    
  if ( run ){
    x = (1+dt)*tamer.x;
    y = (1+dt)*tamer.y;
  }else{  
    PVector m_lion = PVector.mult(lion, -1);
    float theta = PVector.angleBetween(m_lion, tamer);
    
    float d_theta = ((lion_direction*theta<0)?-1:1) * theta * r * 4 * 0.25;
    println(theta+" "+d_theta+" "+dt);
    float sq_d_theta = min( sq(dt), sq( d_theta ) );
  
    float d_r = sqrt( sq(dt) - sq_d_theta );
    PVector d_tamer = new PVector(d_r, d_theta);
    d_tamer.rotate( tamer.heading() );
    d_tamer.setMag(dt);
    println(tamer + "|" + d_tamer);
    x = tamer.x + d_tamer.x;
    y = tamer.y + d_tamer.y;
  }
  
  return new PVector(x,y);
}
PVector moveTamer_zigzag(float dt, float r){
  float x,y;
  
  float eps = 0.02;
  float p_runFactor = runFactor;
  runFactor = 1-PVector.angleBetween(lion, tamer)/4 + eps;
  println( runFactor );
  if ( r>eps &&  runFactor < r )
    can_run = true;
  if ( can_run && runFactor > p_runFactor )
    run = true;
  
  if ( !run ){
    /*
    if ( ( lion.y>0 && lion_direction<0 )
       ||( lion.y<0 && lion_direction>0 ) ){
        x = tamer.x;
        y = tamer.y+((lion.y<0)?dt:-dt);
    }else{
        x = tamer.x+dt;
        y = tamer.y;
    }
    */
    float m = tamer.mag();
    float a = (lion_direction < 0)?1:-1;
    
    PVector dir = PVector.fromAngle( tamer.heading() - a*45);
    x = tamer.x + dt*dir.x ;
    y = tamer.y + dt*dir.y ;
    
  }else{
    x = (1+dt)*tamer.x;
    y = (1+dt)*tamer.y;
  }
  
  return new PVector(x,y);
}

PVector lion;
PVector tamer;
float w, h;
float dt = 0.005;
float lion_speed = 4;
float tamer_speed = 1;
float lion_theta;
float lion_direction = 0;
boolean run = false;
boolean can_run = false;
float runFactor = 0;
void setup(){
 size(500,500,P2D);
 w = width/2;
 h = height/2;
 ellipseMode(CENTER);
 rectMode(CENTER);
 
 lion_theta = PI;
 lion = new PVector( cos(lion_theta), sin(lion_theta));
 tamer = new PVector(0,0);
 
}

void draw(){
 translate(w,h);
 
 noStroke();
 fill(200,2);
 rect(0,0,width,height);

 
 fill(100,0,0);
 ellipse(w*lion.x,h*lion.y, 10,10);
 
 if (run)
   fill(0,100,100);
 else
   fill(0,0,100);
 ellipse(w*tamer.x,h*tamer.y, 10, 10);
 
 float speed = moveTamer(dt);
 moveLion(speed); 
 
 noFill();
 stroke(1);
 ellipse(0,0,width,height);
 
 stroke(1, 10);
 line(w*tamer.x, h*tamer.y, w*lion.x, h*lion.y);
 
}

void mouseClicked(){
 float x = mouseX/w - 1;
 float y = mouseY/h - 1;
 
 float speed = sqrt(sq(tamer.x-x)+sq(tamer.y-y));
 moveLion(speed);
 
 tamer.x = x;
 tamer.y = y;
  
 println(tamer.x+" "+tamer.y+" speed: "+speed);
 //println(PVector.cross(lion, tamer).z);
  println(tamer.cross(lion).z);
  
}

