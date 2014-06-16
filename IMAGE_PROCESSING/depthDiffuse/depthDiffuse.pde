PImage iDepth;

float[] data;
float[] srcStrength, srcValue;

final float SQRT2 = sqrt(2);
int nIterations = 2;

int w;
int h; 
int iteration=0;

void setup(){
  iDepth = loadImage("../../DATA/DEPTH/depth.png");
  w = iDepth.width;
  h = iDepth.height;
  println("w : "+w+"   h : "+h);
  size(3*w,h);
  colorMode(RGB,1);
  
  data = new float[w*h];
  for (int i=0; i<w*h; ++i){
   data[i] = 0; 
  }
  srcStrength = new float[w*h];
  srcValue = new float[w*h];
  for(int i=0; i<h*w; ++i){
    srcValue[i] = 1;
    srcStrength[i] = 0;
  }
  srcStrength[w/2+w*(h/2)] = 1;
  for(int i=0; i<h*w; ++i){
    data[i] = srcStrength[i]*srcValue[i]+(1-srcStrength[i])*data[i];
  }
}

void draw(){
  for(int k=0; k<nIterations;++k){
    data = poissonIteration(data,w,h);
    for(int i=0; i<h*w; ++i){
      data[i] = srcStrength[i]*srcValue[i]+(1-srcStrength[i])*data[i];
    }
  }
  println("iteration : "+(++iteration));
  

  
  image(iDepth,0,0);
  image(getImage(data,w,h),w,0);
}



void iteration(float[] data, int w, int h){
  
}

float[] poissonIteration(float[] data0, int w, int h){
  float[] data = new float[w*h];

  for (int j=1; j<h-1; ++j){
    for (int i=1; i<w-1; ++i){
      data[i+w*j] = (data0[i+w*j+1]+data0[i+w*j-1]+data0[i+w*j+w]+data0[i+w*j-w])/4;
    }  
  }
  
  for (int j=1; j<h-1; ++j){
    data[w*j] = (2*data0[w*j+1]+data0[w*j+w]+data0[w*j-w])/4;
    data[w-1+w*j] = (2*data0[w-1+w*j-1]+data0[w-1+w*j+w]+data0[-1+w*j])/4;
  }
  for (int i=1; i<w-1; ++i){
    data[i] = (data0[i+1]+data0[i-1]+2*data0[i+w])/4;
    data[i+w*(h-1)] = (data0[i+w*(h-1)+1]+data0[i+w*(h-1)-1]+2*data0[i+w*(h-1)-w])/4;
  }
  
  data[0] = 2*(data0[1]+data0[w])/4;                        // i= 0,   j= 0
  data[w-1] = 2*(data0[w-1-1]+data0[w-1+w])/4;              // i= w-1, j= 0
  data[w*(h-1)] = 2*(data0[w*(h-1)+1]+data0[w*(h-1)-w])/4;  // i= 0,   j= h-1
  data[w*h-1] = 2*(data0[w*h-1-1]+data0[w*h-1-w])/4;        // i= w-1, j= h-1

  return data;
}

float[] getData(PImage img){
  int w = img.width;
  int h = img.height;
  float[] data = new float[w*h];
  img.loadPixels();
  for (int i=0; i<w*h; ++i) {
    data[i] = float(img.pixels[i] & 0xFF);
  } 
  img.updatePixels();
  return data;
}
PImage getImage(float[] data, int w, int h){
  PImage rlt = new PImage(w, h);
  rlt.loadPixels();
  for (int i=0; i<w*h; ++i) {
    rlt.pixels[i] = color(data[i]);
  } 
  rlt.updatePixels();
  return rlt;
}
