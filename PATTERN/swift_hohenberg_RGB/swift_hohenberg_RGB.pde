PImage image;

boolean show_r, show_g, show_b; 
float[] u_r, u_g, u_b;

void setup(){
  colorMode(RGB,1.0);
  show_r = show_g = show_b = true;
  
  //image = loadImage("../../DATA/DEPTH/depth.png");
  image = loadImage("../../DATA/PHOTO/Koala_mini.jpg");
 
  size(image.width, image.height);
  
  initialize();  
}

void initialize(){
  u_r = new float[width*height];
  u_g = new float[width*height];
  u_b = new float[width*height];
  for (int i=0; i<width*height; ++i){
    u_b[i] = (image.pixels[i] & 0xff)/255.f;
    u_g[i] = ((image.pixels[i] >> 8) & 0xff)/255.f;
    u_r[i] = ((image.pixels[i] >> 16) & 0xff)/255.f;
  }
  
  u_r = fastGaussian(u_r, width, height);
  u_g = fastGaussian(u_g, width, height);
  u_b = fastGaussian(u_b, width, height);
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
float dd=0.01;
float dr=0.1;

void draw(){
  
  loadPixels();
  for (int i=0; i<pixels.length; ++i){
    float r = (show_r)?map(u_r[i], 0, 1, 0, 1):0;
    float g = (show_g)?map(u_g[i], 0, 1, 0, 1):0;
    float b = (show_b)?map(u_b[i], 0, 1, 0, 1):0;
    pixels[i] = color( r, g, b );
  }
  updatePixels();
  
  swift_hohenberg(u_r);
  swift_hohenberg(u_g);
  swift_hohenberg(u_b);
}

void swift_hohenberg(float[] u){
  float[] du = fastGaussian(u, width, height);
  //float[] du = diffuse(u, width, height);
  float[] ddu = fastGaussian(du, width, height);
  //float[] ddu = diffuse(du, width, height);
  float[] ru = react_u(u, width, height);
  
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

float epsilon = 0.2; float g1 = 0.9;
float[] react_u(float[] u, int w, int h){
  float[] ru = new float[w*h];
  for (int i=0; i<u.length; ++i){
    ru[i] = epsilon*u[i] + g1*pow(u[i],2) - pow(u[i],3);
  }
  return ru;
}

void mouseDragged(){
  int x = mouseX;
  int y = mouseY;

  addPerturbation(u_r, x, y);
}

void keyPressed(){
 if (key == 'r' || key == 'R') {
   show_r = !show_r;
 }
 if (key == 'g' || key == 'G') {
   show_g = !show_g;
 }
 if (key == 'b' || key == 'B') {
   show_b = !show_b;
 }
 if (key == 's' || key == 'S') {
   save("../../result.png");
   print("Saving result.png\n");
 }
}

