// Utility functions

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
    if(data[i]>1)
      rlt.pixels[i] = color(0,0,data[i]);
    else if(data[i]<0)
      rlt.pixels[i] = color(0,data[i],0);
    else
      rlt.pixels[i] = color(data[i]);
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

float[] gaussKernel5 = {1./273, 4./273, 7./273, 4./273,1./273,
                        4./273,16./273,26./273,16./273,4./273,
                        7./273,26./273,41./273,26./273,7./273,
                        4./273,16./273,26./273,16./273,4./273,
                        1./273, 4./273, 7./273, 4./273,1./273};

float[] gaussianBlur(float[] data, int w, int h){
  float[] rlt = new float[w*h];
  for(int i=0; i<w*h; ++i){
     rlt[i] = 0; 
  }
  
  for(int i=2; i<w-2;++i){
    for(int j=2; j<h-2;++j){
      if(i-2<0 || i+2>=w || j-2<0 || j+2>=h){ // Bords
        for(int di=-2;di<3;++di){
          for(int dj=-2;dj<3;++dj){
            int ii = i+di;
            int jj = j+dj;
            
            if(ii<0)
              ii = -ii;
            else if(ii>=w)
              ii = 2*(w-1)-ii;
            if(jj<0)
              jj = -jj;
            else if(jj>=w)
              jj = 2*(w-1)-jj;
              
            rlt[i+w*j] += data[ii+w*jj]*gaussKernel5[di+2+5*(dj+2)];
          }
        }
      }else{ // Interieur de l'image
        for(int di=-2;di<3;++di){
          for(int dj=-2;dj<3;++dj){
            rlt[i+w*j] += data[(i+di)+w*(j+dj)]*gaussKernel5[di+2+5*(dj+2)];
          }
        }
      }
    }
  }
  
  return rlt;
}
