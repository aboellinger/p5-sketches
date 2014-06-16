
float[] u;
float[] v;
void setup(){
  colorMode(RGB,1.0);
  size(500,500);
  initialize();
  
}



void initialize(){
  u = new float[width*height];
  for (int i=0; i<u.length; ++i){
    u[i] = random(1);
    
  } 
  //addPerturbation(u, width/2, height/2);
}

void addPerturbation( float[] u, int x, int y){
  for (int i=0; i<u.length; ++i){
    float a = cos( PI * (float(i%width) - x) / width )
            * cos( PI * (float(i/width) - y) / height );
    a = pow(a,2000) ;
    u[i] = max( u[i], a);
    //u[i] = random(0.);
  }
}

float dt=1;
float dd=1.0;
float dr=0.1;
void draw(){
  
  loadPixels();
  for (int i=0; i<pixels.length; ++i){
    float r = map(u[i], 0, 1, 0, 1);
    float g = r;
    float b = r;
    pixels[i] = color( r, g, b );
  }
  updatePixels();
  
  float[] du = diffuse(u, width, height);
  //du = gaussianBlur( du, width, height);
  float[] ddu = diffuse(du, width, height);
  //ddu = gaussianBlur( ddu, width, height);
  float[] ru = react_u(u, v, width, height);
  
  for (int i=0; i<u.length; ++i){
    u[i] += (-(u[i]+2*du[i]+ddu[i])*dd+ru[i]*dr)*dt;
    
  }
}

float[] diffuse(float[] u, int w, int h){
  
  float[] du = new float[w*h];
  for (int i=0; i<u.length; ++i){
    int x = i%w;
    int y = i/w;
    du[i] = 12*u[i];
    boolean N,S,E,W;
    E = x >  0 ;
    W = x < w-1;
    N = y >  0 ;
    S = y < h-1;
    
    du[i]+= -2*((E)?u[i-1]:u[i]);
    du[i]+= -2*((W)?u[i+1]:u[i]);
    du[i]+= -2*((N)?u[i-w]:u[i]);
    du[i]+= -2*((S)?u[i+w]:u[i]);
    
    du[i]+= -((N&&E)?u[i-1-w]:u[i]);
    du[i]+= -((S&&E)?u[i-1+w]:u[i]);
    du[i]+= -((N&&W)?u[i+1-w]:u[i]);
    du[i]+= -((S&&W)?u[i+1+w]:u[i]);
    
    du[i]/=-12;
    
  }
  return du;
}

float[] gaussianBlur(float[] u, int w, int h){
  
  float[] du = new float[w*h];
  for (int i=0; i<u.length; ++i){
    int x = i%w;
    int y = i/w;
    du[i] = 12*u[i];
    boolean N,S,E,W;
    E = x >  0 ;
    W = x < w-1;
    N = y >  0 ;
    S = y < h-1;
    
    du[i]+= 2*((E)?u[i-1]:u[i]);
    du[i]+= 2*((W)?u[i+1]:u[i]);
    du[i]+= 2*((N)?u[i-w]:u[i]);
    du[i]+= 2*((S)?u[i+w]:u[i]);
    
    du[i]+= ((N&&E)?u[i-1-w]:u[i]);
    du[i]+= ((S&&E)?u[i-1+w]:u[i]);
    du[i]+= ((N&&W)?u[i+1-w]:u[i]);
    du[i]+= ((S&&W)?u[i+1+w]:u[i]);
    
    du[i]/=24;
    
  }
  return du;
}


float epsilon = 0.1; float g1 = 0.1;
float[] react_u(float[] u, float[] v, int w, int h){
  float[] ru = new float[w*h];
  for (int i=0; i<u.length; ++i){
    ru[i] = epsilon*u[i] + g1*pow(u[i],2) - pow(u[i],3);
  }
  return ru;
}

void mouseClicked(){
  int x = mouseX;
  int y = mouseY;

  addPerturbation(u,x,y);
}

