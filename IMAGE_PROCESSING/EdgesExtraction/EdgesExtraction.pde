PImage iDepth, iEdges, iInflexion;

float SCALE_FACTOR = 255;

int w;
int h;

void setup() {
  iDepth = loadImage("../../DATA/DEPTH/depth.png");
  w = iDepth.width;
  h = iDepth.height;
  size(3*w, h);
  colorMode(RGB, 1);

  float[] data = getData(iDepth);   // 0-order

  float[] dx = getDx(data,w,h);
  float[] dy = getDy(data,w,h);    // 1st order

  float[] dx2 = getDx(dx,w,h);
  float[] dy2 = getDy(dy,w,h);  // 2nd order
  float[] dxy = getDy(dx,w,h);
  float[] dyx = getDx(dy,w,h);

  float[] divergence =  new float[w*h]; // Magnitude du gradient
  for (int i=0; i<w*h; ++i) {
    edges[i] = sqrt(sq(dx[i])+sq(dy[i]));
  }
  float[] laplacian =  new float[w*h];     // Laplacien
  for (int i=0; i<w*h; ++i) {
    laplacian[i] = sqrt(sq(dx2[i])+sq(dy2[i]));
  }

  image(iDepth,0,0);

//  image(getImage(dx,w,h),w,  0,  w/2,h/2);
//  image(getImage(dy,w,h),w,  h/2,w/2,h/2);

//  image(getImage(dx2,w,h),3*w/2,0,  w/2,h/2);
//  image(getImage(dy2,w,h),3*w/2,h/2,w/2,h/2);
//  image(getImage(dxy,w,h),2*w,  0,  w/2,h/2);
//  image(getImage(dyx,w,h),2*w,  h/2,w/2,h/2);

  image(getImage(divergence,w,h),w,0);
  image(getImage(laplacian,w,h),2*w,0);

}

float[] getData(PImage img){
  int w = img.width;
  int h = img.height;
  float[] data = new float[w*h];
  img.loadPixels();
  for (int i=0; i<w*h; ++i) {
    data[i] = float(img.pixels[i] & 0xFF)/SCALE_FACTOR;
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

