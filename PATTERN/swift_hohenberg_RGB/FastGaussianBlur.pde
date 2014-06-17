
// Kernel 9, sigma^2 = 4
float[] kernel_9 = {
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

// Kernel 5, sigma^2 = 2
float[] kernel = { 
  0.11170336406408216, 
  0.23647602357935057, 
  0.30364122471313454, 
  0.23647602357935057, 
  0.11170336406408216, 
};
int kernel_width = 5;

float[] fastGaussian(float[] u, int w, int h){
  return gaussianBlurV(gaussianBlurH(u, w, h), w, h);
}

float[] gaussianBlurH(float[] u, int w, int h){
  float[] du = new float[w*h];

  int kw = kernel_width;
  int hkw = kernel_width/2;

  for (int y=0; y<h; ++y){   
    // Left 
    for (int x=0; x<hkw; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<kw; ++k){
        int ii = y*w + max(0, x+k-hkw);
        du[i] += kernel[k] * u[ii];
      }
    }
    // Right
    for (int x=w-1-hkw; x<w; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<kw; ++k){
        int ii = y*w + min(w-1, x+k-hkw);
        du[i] += kernel[k] * u[ii];
      }
    }
    // Center
    for (int x=hkw; x<w-hkw; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<kw; ++k){
        int ii = y*w + x+k-hkw;
        du[i] += kernel[k] * u[ii];
      }
    }
  }
  
  return du;
}

float[] gaussianBlurV(float[] u, int w, int h){
  float[] du = new float[w*h];

  int kw = kernel_width;
  int hkw = kernel_width/2;

  // Up 
  for (int y=0; y<hkw; ++y){
    for (int x=0; x<w; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<kw; ++k){
        int ii = w*max(0, y+k-hkw) + x;
        du[i] += kernel[k] * u[ii];
      }
    }
  }
  // Bottom
  for (int y=h-1-hkw; y<h; ++y){
    for (int x=0; x<w; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<kw; ++k){
        int ii = w*min(h-1, y+k-hkw) + x;
        du[i] += kernel[k] * u[ii];
      }
    }
  }
  // Center
  for (int y=hkw; y<h-hkw; ++y){
    for (int x=0; x<w; ++x){
      int i = y*w + x;
      du[i] = 0;
      for (int k=0; k<kw; ++k){
        int ii = w*(y+k-hkw) + x;
        du[i] += kernel[k] * u[ii];
      }
    }
  }
  
  return du;
}
