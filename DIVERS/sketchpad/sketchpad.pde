
PGraphics pg;
int step = 1;
float mouseX0, mouseY0;

void setup(){
  size(500,500, P2D);
  pg = createGraphics(width, height, P2D);
  mouseX0 = mouseY0 = 0;
}

void draw(){
  background(222);
  // Update pg :   
  if (mousePressed){    
    pg.beginDraw();
    pg.fill(100);
    pg.noStroke();
    pg.ellipseMode(CENTER);
    pg.ellipse(mouseX,mouseY,10,10);
    pg.endDraw();
  }
  
  image(pg,0,0);
  
  noFill();
  ellipseMode(CENTER);
  ellipse(mouseX,mouseY,10,10);
  
  mouseX0 = mouseX;
  mouseY0 = mouseY;
}
