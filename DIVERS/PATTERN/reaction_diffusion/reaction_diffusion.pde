
float[] u;
void setup(){
  colorMode(HSB,1.0);
  size(100,100);
  u = new float[width*height];
  for (int i=0; i<u.length; ++i){
    u[i] = sin( PI * float(i%width) / width )
          *sin( PI * float(i/width) / height );
    u[i] = pow(u[i],1000)*0.9 + random(0.1);
  }
  
}

void draw(){
  
  loadPixels();
  for (int i=0; i<pixels.length; ++i){
    pixels[i] = color(u[i]);
  }
  updatePixels();
  
  float[] du = diffuse(u, width, height);
  float[] ru = react(u, width, height);
  
  for (int i=0; i<u.length; ++i){
    u[i] += ( -0.1*du[i] + ru[i] )*0.01;
  }
}

float[] diffuse(float[] u, int w, int h){
  float[] du = new float[w*h];
  for (int i=0; i<u.length; ++i){
    int x = i%w;
    int y = i/w;
    du[i] = 0.8*u[i];
    du[i]+= (x> 0 )?-0.2*u[i-1]:0;
    du[i]+= (x<w-1)?-0.2*u[i+1]:0;
    du[i]+= (y> 0 )?-0.2*u[i-w]:0;
    du[i]+= (y<h-1)?-0.2*u[i+w]:0;
  }
  return du;
}

float[] react(float[] u, int w, int h){
  float[] ru = new float[w*h];
  for (int i=0; i<u.length; ++i){
    ru[i] = u[i]*(1-u[i]);
    //ru[i] = u[i]*u[i]*(1-u[i]);
  }
  return ru;
}
