
float[] u;
float[] v;
void setup(){
  colorMode(RGB,1.0);
  size(500,500);
  initialize();
  
}



void initialize(){
  u = new float[width*height];
  v = new float[width*height];
  for (int i=0; i<v.length; ++i){
    //u[i] = random(0.1);
    //v[i] = random(0.2);
  } 
  addPerturbation(u, width/2, height/2);
}

void addPerturbation( float[] u, int x, int y){
  for (int i=0; i<u.length; ++i){
    float a = cos( PI * (float(i%width) - x) / width )
            * cos( PI * (float(i/width) - y) / height );
    a = pow(a,2000) ;//+ random(0.1);
    u[i] = max( u[i], a);
    //u[i] = random(0.);
  }
}

float dt=1;
float dd=1.0;
float dr=1.0;
void draw(){
  
  loadPixels();
  for (int i=0; i<pixels.length; ++i){
    //pixels[i] = color(v[i], v[i], v[i]);
    //pixels[i] = color(u[i], u[i], u[i]);
    float r = map(u[i], -0.5, 0.5, 0, 1);
    float g = map(v[i], -0.5, 0.5, 0, 1);
    float b=0;
    pixels[i] = color( r, g, b );
  }
  updatePixels();
  
  float[] du = diffuse(u, width, height);
  float[] dv = diffuse(v, width, height);
  //float[] du = multidiffuse(u, width, height, 1);
  //float[] dv = multidiffuse(v, width, height, 1);
  float[] ru = react_u(u, v, width, height);
  float[] rv = react_v(u, v, width, height);
  
  for (int i=0; i<u.length; ++i){
    u[i] += (du[i]*dd + ru[i]*dr)*dt;
    //v[i] += (dv[i]*dd + rv[i]*dr)*dt;
    v[i] += rv[i]*dr*dt;
    
    //u[i] = constrain(u[i], 0.0, 1.0);
    //v[i] = constrain(v[i], 0.0, 1.0);
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

float ru_a=0.2; float ru_b=0.1; float ru_c=0.0; float ru_d=0.1;
//float ru_a=0.5; float ru_b=0.1; float ru_c=0.0; float ru_d=0.5;
//float ru_a=0.1; float ru_b=0.9; float ru_c=0.5; float ru_d=0.1; float ru_e=0.2;

//float i_ext = 0.0; float epsilon = 0.01; float a = 0.1; float b = 0.9; // FHN 
float i_ext = 0.0; float epsilon = 0.01; float a = 0.1; float b = 0.9; 
float[] react_u(float[] u, float[] v, int w, int h){
  float[] ru = new float[w*h];
  for (int i=0; i<u.length; ++i){
    //ru[i] = u[i]*(0.5-u[i]); // Fischer
    //ru[i] = u[i]*(0.5-pow(u[i],2)); // Raylegh-Benard
    //ru[i] = ru_a*u[i] - ru_b*pow(u[i],3) - ru_c - ru_d*v[i];
    //ru[i] = u[i]*(1-u[i]);
    //ru[i] = u[i] * (0.5-v[i]); // Volterra
    //ru[i] = ru_a - ru_b*u[i] + ru_c*pow(u[i],2)*v[i]; // Schnakenberg
    //ru[i] = ru_a - ru_b*u[i] + ru_c*pow(u[i],2)/v[i]; // Gierer-Meinhardt
    
    //ru[i] = u[i]*(1 - u[i])*(u[i] - a) - v[i] + i_ext; // FHN
  }
  return ru;
}

float[] react_v(float[] u, float[] v, int w, int h){
  float[] rv = new float[w*h];
  for (int i=0; i<u.length; ++i){
    //rv[i] = ( u[i] - v[i] );
    //rv[i] = u[i]*u[i]*(1-u[i]);
    //rv[i] = 2*v[i] * (u[i]-0.5); // Volterra
    //rv[i] = ru_d - ru_c*pow(u[i],2)*v[i]; // Schnakenberg
    //rv[i] = ru_d*pow(u[i],2) - ru_e*v[i]; // Gierer-Meinhardt
    
    //rv[i] = epsilon*(b*u[i] - v[i]); // FHN
  }
  return rv;
}

void mouseClicked(){
  int x = mouseX;
  int y = mouseY;

  addPerturbation(u,x,y);
}

