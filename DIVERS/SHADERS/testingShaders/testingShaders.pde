PShader flatShader;

void setup() {
  size(640, 360, P3D);
  
  flatShader = loadShader("frag.glsl", "vert.glsl");
  
  shader(flatShader);
}

void draw() {
  background(0);
  noStroke();
  fill(10, 30, 30);
  rotateX(PI/6);
  rotateY(PI/6);
  translate(mouseX, mouseY);
  box(100,200,500);
  //rect(10, 10, width - 20, height - 20);
}
