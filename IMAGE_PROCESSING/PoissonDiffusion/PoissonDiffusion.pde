PImage iDepth;

float[] data,f;
float[] srcStrength, srcValue;
boolean[] isSrc;

final int minDim = 16;

int w;
int h; 
int iterationCount=0;

void setup(){
  iDepth = loadImage("depth.png");
  iDepth.resize(256,256);
  w = iDepth.width;
  h = iDepth.height;
  println("w : "+w+"   h : "+h);
  size(3*w,h);
  colorMode(RGB,1);
  
  float[] original = getData(iDepth);
  
  data = new float[w*h];
  f = new float[w*h];
  {
    float[] data = getData(iDepth);   // 0-order
    float[] dx = getDx(data,w,h);
    float[] dy = getDy(data,w,h);     // 1st order
    float[] dx2 = getDx(dx,w,h);
    float[] dy2 = getDy(dy,w,h);      // 2nd order
    
    for (int i=0; i<w*h; ++i) {
      f[i] = dx2[i]+dy2[i];
    }
  }
  for (int i=0; i<w*h; ++i){
   data[i] = 0.5;
  }
  
  srcStrength = new float[w*h];
  srcValue = new float[w*h];
  isSrc = new boolean[w*h];
  for(int i=0; i<h*w; ++i){
    srcValue[i] = 0;
    isSrc[i] = false;
    srcStrength[i] = 0;
    if((i/w==0)||(i/w==h)||(i%w==0)||(i%w==w)){
   // if((i/w<50)||(i/w>h-50)||(i%w==0)||(i%w==w)){
      srcValue[i] = original[i];
      isSrc[i] = true;
      srcStrength[i] = 1; 
    }
  }

//  srcStrength[w/3+w*(h/3)] = 1; 
//  srcValue[2*w/3+w*(2*h/3)] = 0;
//  srcStrength[2*w/3+w*(2*h/3)] = 1;

  for(int i=0; i<h*w; ++i){
    //data[i] = srcStrength[i]*srcValue[i]+(1-srcStrength[i])*data[i];
    data[i] = isSrc[i]?srcValue[i]:data[i];
  }
  

}

void draw(){
  
  if(iterationCount==0){
    
  }
  
  // Compute data laplacian
   float[] LData = computeLaplacian(data,w,h);
//  float[] LData = new float[w*h];
//  {
//    float[] dx = getDx(data,w,h);
//    float[] dy = getDy(data,w,h);     // 1st order
//    float[] dx2 = getDx(dx,w,h);
//    float[] dy2 = getDy(dy,w,h);      // 2nd order
//    
//    for (int i=0; i<w*h; ++i) {
//      LData[i] = dx2[i]+dy2[i];
//    }
//  }
  
  
  //*
  float[] r = new float[h*w]; // Si on est au niveau le plus bas on initialise la correction à 0
  for(int i=0; i<h*w; ++i){
     r[i]=LData[i] - f[i];
  }
  float[] c = multiscalePoissonIteration(r,isSrc,w,h,0);

  for(int i=0; i<h*w; ++i){
     data[i]-=c[i];
  }  
  
   

   //*/
  
//   for(int it=0; it<100; ++it){  
//    poissonIteration(data,w,h,f); // Finalement on diffuse
//  }
  
  
  for(int i=0; i<h*w; ++i){
    data[i] = isSrc[i]?srcValue[i]:data[i];
  }
   
   
//  if(iterationCount==0){
//   data = multiscalePoissonIteration(data,w,h,srcStrength,srcValue,0);
//  }else{
//   data = multiscalePoissonIteration(data,w,h,0);
//   for(int i=0; i<h*w; ++i){ // On restaure les points source
//    data[i] = srcStrength[i]*srcValue[i]+(1-srcStrength[i])*data[i];
//   }  
//  }
  println("iterationCount : "+(++iterationCount)+"   "+data[10000]);

  
  image(getImage(getData(iDepth),w,h),0,0);
  image(getImage(data,w,h),w,0);
  image(getImage(c,w,h),2*w,0);
//  image(getImage(srcStrength,w,h),2*w,0);
  
  
}



// La meme sans source
float[] multiscalePoissonIteration(float[] r, boolean[] isSrc, int w, int h, int level){
  float[] c, c1;
  float[] r1 = scaleDown(r,w,h);
  boolean[] isSrc1 = scaleDown(isSrc,w,h);
  
  if (r1!=null){ // Si pas assez petit, on le réduit on diffuse, puis on l'agrandit
    c1 = multiscalePoissonIteration(r1,isSrc1, w/2, h/2, level+1);
    c = scaleUp(c1,w,h);
  }else{
    c = new float[h*w]; // Si on est au niveau le plus bas on initialise la correction à 0
    for(int i=0; i<h*w; ++i){
     c[i]=0;
    }
  }
  
  for(int it=0; it<1000; ++it){  
    poissonIteration(c,w,h,r); // Finalement on diffuse
    for(int i=0; i<h*w; ++i){
     if(isSrc[i]) c[i]=0;
    }
  }
  
  return c;
}

float[] scaleDown(float data0[],int w0,int h0){
 if (w0<minDim || h0<minDim) return null; // On teste si on a atteint la taille limite
 int w = w0/2;
 int h = h0/2;
 
 float[] data = new float[h*w];
 for(int j = 0; j<h; ++j){
   for(int i = 0; i<w; ++i){
     data[i+w*j] = (data0[2*i+w0*2*j]+data0[2*i+1+w0*2*j]+data0[2*i+w0*(2*j+1)]+data0[2*i+1+w0*(2*j+1)])/4;
   }  // On ignore les éventuelles derniere colonnes et lignes
 }
 
  if(w0%2==1){ // Derniere colonne
   for(int j=0; j<h; ++j){
     data[w-1+w*j] = data[w-1+w*j]*0.66 + (data0[w0-1+w0*2*j]+data0[w0-1+w0*(2*j+1)])*0.5*0.34;
   }
 }
 if(h0%2==1){ // Derniere ligne
   for(int i=0; i<w; ++i){
     data[i+w*(h-1)] = data[i+w*(h-1)]*0.66 + (data0[2*i+w0*(h0-1)]+data0[2*i+1+w0*(h0-1)])*0.5*0.34;
   } 
 }
 
 
 return data;
}

boolean[] scaleDown(boolean data0[],int w0,int h0){
 if (w0<minDim || h0<minDim) return null; // On teste si on a atteint la taille limite
 int w = w0/2;
 int h = h0/2;
 
 boolean[] data = new boolean[h*w];
 for(int j = 0; j<h; ++j){
   for(int i = 0; i<w; ++i){
     data[i+w*j] = data0[2*i+w0*2*j] || data0[2*i+1+w0*2*j] || data0[2*i+w0*(2*j+1)] || data0[2*i+1+w0*(2*j+1)];
   }  // On ignore les éventuelles derniere colonnes et lignes
 }
 
 return data;
}

float[] scaleUp(float data0[], int w, int h){
 int w0 = w/2;
 int h0 = h/2;
 if(data0.length!=(w0*h0)) print("Errrreur de dimensions !!!");
 
 float[] data = new float[w*h];
 for(int j0 = 0; j0<h0; ++j0){
   for(int i0 = 0; i0<w0; ++i0){
     data[2*i0   + w*(2*j0)]   = 
     data[2*i0+1 + w*(2*j0)]   = 
     data[2*i0   + w*(2*j0+1)] = 
     data[2*i0+1 + w*(2*j0+1)] = data0[i0+w0*j0];
   }
 }
 
 if(w%2==1){ // Derniere colonne
   for(int j=0; j<h; ++j){
     data[w-1+w*j] = data[w-2+w*j];
   }
 }
 if(h%2==1){ // Derniere ligne
   for(int i=0; i<w; ++i){
     data[i+w*(h-1)] = data[i+w*(h-1)-w];
   } 
 }
 
 return data;
}

void poissonIteration(float[] data, int w, int h, float[] f){
//*************** JACODBI ITERATION ***********************************
  float[] data0 = new float[w*h];
  for (int i=0; i<w*h; ++i){
   data0[i] = data[i]; 
  }
  
  // Pixels interieurs
  for (int j=1; j<h-1; ++j){ 
    for (int i=1; i<w-1; ++i){
      data[i+w*j] = (data0[i+w*j+1]+
                      data0[i+w*j-1]+
                      data0[i+w*j+w]+
                      data0[i+w*j-w]-f[i+w*j])/4;
    }  
  }
  
  // Pixels bords
  for (int j=1; j<h-1; ++j){ 
    data[w*j] = (2*data0[w*j+1]+
                    data0[w*j+w]+
                    data0[w*j-w]-f[w*j])/4;
    data[w-1+w*j] = (2*data0[w-1+w*j-1]+
                        data0[w-1+w*j+w]+
                        data0[-1+w*j]-f[w-1+w*j])/4;
  }
  for (int i=1; i<w-1; ++i){
    data[i] = (data0[i+1]+
                data0[i-1]+
                2*data0[i+w]-f[i])/4;
    data[i+w*(h-1)] = (data0[i+w*(h-1)+1]+
                        data0[i+w*(h-1)-1]+
                        2*data0[i+w*(h-1)-w]-f[i+w*(h-1)])/4;
  }
  
  // Pixels coins
  data[0] = (2*(data0[1]+ 
                 data0[w])-f[0])/4;                // i= 0,   j= 0
  data[w-1] = (2*(data0[w-1-1]+
                   data0[w-1+w])-f[w-1])/4;          // i= w-1, j= 0
  data[w*(h-1)] = (2*(data0[w*(h-1)+1]+
                       data0[w*(h-1)-w])-f[w*(h-1)])/4;  // i= 0,   j= h-1
  data[w*h-1] = (2*(data0[w*h-1-1]+
                     data0[w*h-1-w])-f[w-1+w*(h-1)])/4;      // i= w-1, j= h-1
}

float[] computeLaplacian(float[] data, int w, int h){
  float[] L = new float[w*h];
  
  // Pixels interieurs
  for (int j=1; j<h-1; ++j){ 
    for (int i=1; i<w-1; ++i){
      L[i+w*j] = -4*data[i+w*j]+
                      (data[i+w*j+1]+
                      data[i+w*j-1]+
                      data[i+w*j+w]+
                      data[i+w*j-w]);
    }  
  }
  
  // Pixels bords
  for (int j=1; j<h-1; ++j){ 
    L[w*j] = -4*data[w*j]+
                    (2*data[w*j+1]+
                    data[w*j+w]+
                    data[w*j-w]);
    L[w-1+w*j] = -4*data[w-1+w*j]+
                        (2*data[w-1+w*j-1]+
                        data[w-1+w*j+w]+
                        data[-1+w*j]);
  }
  for (int i=1; i<w-1; ++i){
    L[i] = -4*data[i]+
                (data[i+1]+
                data[i-1]+
                2*data[i+w]);
    L[i+w*(h-1)] = -4*data[i+w*(h-1)]+
                        (data[i+w*(h-1)+1]+
                        data[i+w*(h-1)-1]+
                        2*data[i+w*(h-1)-w]);
  }
  
  // Pixels coins
  L[0] = -4*data[0]+
                 2*(data[1]+ 
                 data[w]);                // i= 0,   j= 0
  L[w-1] = -4*data[w-1]+
                   2*(data[w-1-1]+
                   data[w-1+w]);          // i= w-1, j= 0
  L[w*(h-1)] = -4*data[w*(h-1)]+
                       2*(data[w*(h-1)+1]+
                       data[w*(h-1)-w]);  // i= 0,   j= h-1
  L[w*h-1] = -4*data[w*h-1]+
                     2*(data[w*h-1-1]+
                     data[w*h-1-w]);      // i= w-1, j= h-1

  return L;
}

float[] getData(PImage img){
  int w = img.width;
  int h = img.height;
  float[] data = new float[w*h];
  img.loadPixels();
  for (int i=0; i<w*h; ++i) {
    data[i] = float(img.pixels[i] & 0xFF)/255;
  } 
  img.updatePixels();
  return data;
}
PImage getImage(float[] data, int w, int h){
  PImage rlt = new PImage(w, h);
  rlt.loadPixels();
  for (int i=0; i<w*h; ++i) {
    rlt.pixels[i] = (data[i]<0)?color(-data[i],0,0):color(data[i],data[i],data[i]);
  } 
  rlt.updatePixels();
  return rlt;
}

float[] getDx(float[] data, int w, int h) {
  float[] dx = new float[w*h];
  if (data.length != w*h) {
    print("Error ! dimensions doesn't match");
  }
  for (int i=0; i<w*h; ++i) {
    if (i%w == 0) {          // On est sur la 1ere colonne
      dx[i] = data[i+1] - data[i];
    }
    else if (i%w == w-1) {   // On est sur la derniere colonne
      dx[i] = data[i] - data[i-1];
    }
    else {
      dx[i] = (data[i+1] - data[i-1])/2;
    }
  }

  return dx;
}


float[] getDy(float[] data, int w, int h) { 
  float[] dy = new float[w*h];
  if (data.length != w*h) {
    print("Error ! dimensions doesn't match");
  }
  for (int i=0; i<w*h; ++i) {
    if (i/w == 0) {          // On est sur la 1ere ligne
      dy[i] = data[i+w] - data[i];
    }
    else if (i/w == h-1) {   // On est sur la derniere ligne
      dy[i] = data[i] - data[i-w];
    }
    else {
      dy[i] = (data[i+w] - data[i-w])/2;
    }
  }

  return dy;
}


void mousePressed(){
  color c = get(mouseX,mouseY);
  println("Position : x="+mouseX+" y="+mouseY+"  || Color = r="+red(c)+" g="+green(c)+" b="+blue(c));
}
