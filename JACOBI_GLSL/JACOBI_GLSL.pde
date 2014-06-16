


PImage tex;
PShader jacobiFrag;
PGraphics pgOut;
PGraphics pgIn;

void setup() {
  noCursor();
  tex = loadImage("tex2.jpg");
  
  size(tex.width, tex.height, P2D);
  
  
  colorMode(RGB,1);
  
  pgOut = createGraphics(width, height, P2D);
  //pgOut.noStroke();
  pgOut.colorMode(RGB,1);
  pgOut.textureWrap(CLAMP);
  
  pgIn = createGraphics(width, height, P2D);
  //pgIn.noStroke();
  pgIn.colorMode(RGB,1);
  pgIn.textureWrap(CLAMP);

  jacobiFrag = loadShader("jacobi.frag");
  jacobiFrag.set("resolution", float(width), float(height));
  
  
  pgIn.beginDraw();
  pgIn.image(tex, 0, 0);
  pgIn.endDraw();
}

void draw() {
  
  pgOut.beginDraw();
  pgOut.background(0.5);
  pgOut.shader(jacobiFrag); 
  pgOut.image(pgIn, 0, 0);
  pgOut.endDraw();
  
  image(pgOut, 0, 0);
  
  PGraphics pgTemp = pgIn;
  pgIn = pgOut;
  pgOut = pgTemp;
  

  println( "frameRate = "+frameRate);
  //*/
  
  
}

void mouseDragged(){
  pgIn.beginDraw();
  pgIn.line(pmouseX,pmouseY, mouseX, mouseY);
  pgIn.endDraw();
}

