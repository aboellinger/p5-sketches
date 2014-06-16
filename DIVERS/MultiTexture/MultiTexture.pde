PImage tex;
PShader sha;

void setup(){
  size(500,500,P2D);
  
  
  textureWrap(REPEAT);
  tex = loadImage("3Textures.jpg");
  
  sha = loadShader("mixTex.frag");
  sha.set("resolution", float(width), float(height));
}

void draw(){
  sha.set("mouse", float(mouseX), float(mouseY));
  shader(sha);
  image(tex, 0, 0, width, height);
}
