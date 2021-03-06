
int cnvW = 720;
int cnvH = 480;
PGraphics cnv;
PImage prevImage;

int brushW = 50;
int brushH = 50;
float brushSigma = brushW / 6.0;
PImage brush;

void setup(){
  size(cnvW + 100,cnvH, P2D);
  colorMode(RGB,1.0);
  
  cnv = createGraphics(cnvW, cnvH, P2D);
  cnv.beginDraw();
  cnv.colorMode(RGB,1.0);
  cnv.background(0.9,0.9,0.9);
  //cnv.imageMode(CENTER);
  cnv.endDraw();
  
  prevImage = createImage(cnvW,cnvH,RGB);
  
  
  brush = createImage(brushW,brushH,ARGB);
  gaussianBrush(brushSigma);
  
}

void draw(){
  background(0.4,5.0,0.4);
  
  image(cnv,0,0);
  image(brush,cnvW,0);
  
  // Apercu souris
  imageMode(CENTER);  
  image(brush,mouseX, mouseY);
  imageMode(CORNER);
}

void gaussianBrush(float sigma){
  float x0 = brushW / 2.0f;
  float y0 = brushH / 2.0f;
  float w = 1 / ( 2 * sq(sigma) );
  float lambda = 1; //w/PI ;
  
  brush.loadPixels();
  for (int i=0; i<brush.pixels.length; ++i){

    float sqx = sq( (i % brushW) - x0 );
    float sqy = sq( (i / brushW) - y0 );
    brush.pixels[i] = color(0,lambda * exp(- (sqx+sqy) * w));
  }
  brush.updatePixels();
  
}

void mouseDragged(){
  
  float strokeLength = dist(pmouseX,pmouseY,mouseX,mouseY);
  float dx = (mouseX-pmouseX) / strokeLength;
  float dy = (mouseY-pmouseY) / strokeLength;
  
  cnv.beginDraw();
  for (int i = 0; i < strokeLength; i+=2){
    //cnvTmp.image(brush,pmouseX + i*dx, pmouseY + i*dy);
    cnv.blend(brush,
                  0, 0,
                  brushW, brushH,
                  int(pmouseX + i*dx)-brushW/2, int(pmouseY + i*dy)-brushH/2,
                  brushW, brushH,
                  BLEND);
  }
  cnv.endDraw();
  
}

/*
void mouseDragged(){
  
  float strokeLength = dist(pmouseX,pmouseY,mouseX,mouseY);
  float dx = (mouseX-pmouseX) / strokeLength;
  float dy = (mouseY-pmouseY) / strokeLength;
  
  PGraphics cnvTmp = createGraphics(cnvW, cnvH, P2D);
  cnvTmp.beginDraw();
  cnvTmp.colorMode(RGB,1.0);
  cnvTmp.background(0.0,0.0);
  //cnvTmp.imageMode(CENTER);
  for (int i = 0; i < strokeLength; i+=2){
    //cnvTmp.image(brush,pmouseX + i*dx, pmouseY + i*dy);
    cnvTmp.blend(brush,
                  0, 0,
                  brushW, brushH,
                  int(pmouseX + i*dx)-brushW/2, int(pmouseY + i*dy)-brushH/2,
                  brushW, brushH,
                  BLEND);
    //cnvTmp.point(int(pmouseX + i*dx),int(pmouseY + i*dy));
  }
  cnvTmp.endDraw();
  
  image(cnvTmp,cnvW,brushH,100,100);
  
  cnv.beginDraw();
  cnv.blend(cnvTmp, 0, 0, cnvW, cnvH, 0, 0, cnvW, cnvH, BLEND);
  cnv.endDraw();
  
}
*/
