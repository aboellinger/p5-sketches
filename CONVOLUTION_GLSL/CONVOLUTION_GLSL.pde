import javax.media.opengl.*;
import processing.opengl.*;
// For mouse wheel listenning
import java.awt.event.*;


float mouseFactor = 1;

PImage tex;
PImage ker;
PShader jacobiFrag;
PGraphics pgOut;


void setup() {
  
  
   // Mouse wheel
  addMouseWheelListener(new MouseWheelListener() { 
    public void mouseWheelMoved(MouseWheelEvent mwe) { 
      mouseWheel(mwe.getWheelRotation());
  }}); 
  
  
  noCursor();
  tex = loadImage("tex01.jpg");
  ker = loadImage("ker02.png");
  
  size(tex.width, tex.height, P2D);
  
  
  colorMode(RGB,1);
  
  pgOut = createGraphics(width, height, P2D);
  pgOut.colorMode(RGB,1);
  pgOut.textureWrap(CLAMP);

  jacobiFrag = loadShader("convolve.frag");
  jacobiFrag.set("resolution", float(width), float(height));
  
  float sum = 0;
  ker.loadPixels();
  for (int i=0; i < ker.width*ker.height; ++i){
    color c = ker.pixels[i];
    sum += blue(c);
  }
  ker.updatePixels();
  
  
  jacobiFrag.set("ker", ker);
  jacobiFrag.set("ker_res",  float(ker.width),  float(ker.height) );
  
  jacobiFrag.set("ker_sum", sum);
}

void draw() {
  
  
  jacobiFrag.set("col_factor", mouseFactor);
  jacobiFrag.set("col_mode", (mousePressed)?1.0:0.0);
  
  pgOut.beginDraw();
  pgOut.background(0.5);
  pgOut.shader(jacobiFrag); 
  pgOut.image(tex, 0, 0);
  pgOut.endDraw();
  

  image(pgOut, 0, 0);

  
  if (keyPressed == true) {  
    pushMatrix();
    scale(1,-1);
    image(tex,0,-height);  
    popMatrix();
  }
  
  image(ker,0,0);
  //println( "frameRate = "+frameRate);
  //*/
  
  
}

void mouseWheel(int delta) {
  float factor = 1 + delta * 0.01;
  mouseFactor *= factor;
  println("col_factor : " + mouseFactor);
}

