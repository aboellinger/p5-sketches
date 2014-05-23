MDisk m_disk;
color bg = color(127);

class MDisk{
 PVector pos =new PVector(50,50);
 float rad = 10; 
 
  MDisk(){
    
  }
  
  void move(){
    pos.add(new PVector((noise(frameCount/10,0,0)-0.5),
                      (noise(0,frameCount/10,0)-0.5)));
    rad += (noise(0,0,frameCount/10)-0.5);
  }
}

void setup(){
  m_disk = new MDisk();
  noStroke();
}

void draw(){
  loadPixels();
  for (int i=0; i< width*height; i++){
    int r = (((bg >> 16) & 0xFF)/100 + ((pixels[i] >> 16) & 0xFF));
    int g = (((bg >> 8) & 0xFF)/100 + ((pixels[i] >> 8) & 0xFF));
    int b = ((bg & 0xFF)/100 + (pixels[i] & 0xFF));
    pixels[i] = color(r/1.01,g/1.01,b/1.01);
  }
  updatePixels();
  
  m_disk.move();
  ellipse(m_disk.pos.x,m_disk.pos.y,m_disk.rad,m_disk.rad);
  
}
