
float[] kernel = {
  0.016140081106592156, 
  0.0518301670217077, 
  0.11925996473789614, 
  0.19662644060631496, 
  0.23228669305497798, 
  0.19662644060631496, 
  0.11925996473789614, 
  0.0518301670217077, 
  0.016140081106592156, 
};
int kw = 9;

float[] fastGaussian(float[] u, int w, int h){
  return gaussianBlurV(gaussianBlurH(u, w, h), w, h);
}

float[] gaussianBlurH(float[] u, int w, int h){
  float[] du = new float[w*h];

  for (int y=0; y<h; ++y){   
    // Left 
    for (int x=0; x<4; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<9; ++k){
        int ii = y*w + max(0, x+k-4);
        du[i] += kernel[k] * u[ii];
      }
    }
    // Right
    for (int x=w-5; x<w; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<9; ++k){
        int ii = y*w + min(w-1, x+k-4);
        du[i] += kernel[k] * u[ii];
      }
    }
    // Center
    for (int x=4; x<w-4; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<9; ++k){
        int ii = y*w + x+k-4;
        du[i] += kernel[k] * u[ii];
      }
    }
  }
  
  return du;
}

float[] gaussianBlurV(float[] u, int w, int h){
  float[] du = new float[w*h];

  // Up 
  for (int y=0; y<4; ++y){
    for (int x=0; x<w; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<9; ++k){
        int ii = w*max(0, y+k-4) + x;
        du[i] += kernel[k] * u[ii];
      }
    }
  }
  // Bottom
  for (int y=h-5; y<h; ++y){
    for (int x=0; x<w; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<9; ++k){
        int ii = w*min(w-1, y+k-4) + x;
        du[i] += kernel[k] * u[ii];
      }
    }
  }
  // Center
  for (int y=4; y<h-4; ++y){
    for (int x=0; x<w; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<9; ++k){
        int ii = w*(y+k-4) + x;
        du[i] += kernel[k] * u[ii];
      }
    }
  }
  
  return du;
}
