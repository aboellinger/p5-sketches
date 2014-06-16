
// \\srv-bin\bin\tools\ffmpeg\bin\ffmpeg.exe -r 24 -i "E:\Antoine\Processing\FastVoronoi\VoronoiAnim%03d.png" -f mov -vcodec targa -y E:\Antoine\Processing\FastVoronoi\normalPerturb_0.002.mov 

import javax.media.opengl.*;
import processing.opengl.*;
// For mouse wheel listenning
import java.awt.event.*;


Cone mouseCone;
float mouseRadius = 512;
ArrayList<Cone> staticCones;

void setup(){
  
  // Mouse wheel
  addMouseWheelListener(new MouseWheelListener() { 
    public void mouseWheelMoved(MouseWheelEvent mwe) { 
      mouseWheel(mwe.getWheelRotation());
  }}); 
  
  
  colorMode(RGB, 1.0);
  size(512,512, OPENGL);
  background(0);
  
  // Initialize mouseCone
  mouseCone = new Cone();
  mouseCone.setPosition(0,0,0);
  mouseCone.setVelocity(0,0,0);
  mouseCone.setTriangles(20);
  mouseCone.setRadius(mouseRadius);
  
  // Initialize staticCones
  staticCones = new ArrayList<Cone>();
  
  Cone cone = new Cone();
  cone.setPosition(282,353,0);
  cone.setVelocity(0,0,0);
  cone.setTriangles(40);
  cone.setRadius(mouseRadius);
  // Add it to the list
  staticCones.add( cone );
  
  cone = new Cone();
  cone.setPosition(155,364,0);
  cone.setVelocity(0,0,0);
  cone.setTriangles(40);
  cone.setRadius(mouseRadius);
  // Add it to the list
  staticCones.add( cone );
  
  noCursor();
  
  ortho(0, width, 0, height, -10, 10);
  camera(0,0,-10,0,0,0,0,-1,0);
  noLights();
  
}

void draw(){
  
  //GL gl = ((PGraphicsOpenGL)g).gl;
  // Disable antialiasing and blending, to ensure that color values are not interpolated.
  // This way we have an equivalence color = cone = voronoi cell
  //gl.glDisable(GL.GL_MULTISAMPLE);
  //gl.glDisable(GL.GL_LINE_SMOOTH);
  //gl.glDisable(GL.GL_BLEND);
  
  background(0.0);
  
  
  

  translate(-width/2, -height/2);
  
  
  // Afficher le repère de l'espace
  if (false){
    beginShape(LINES);
       stroke(255,0,0);
       vertex(0,0,0);
       vertex(100,0,0);
       stroke(0,255,0);
       vertex(0,0,0);
       vertex(0,100,0);
       stroke(0,0,255);
       vertex(0,0,0);
       vertex(0,0,100);
     endShape();
   }
   
  // Mouse cone
  mouseCone.setPosition(mouseX,height-mouseY,0);
  mouseCone.draw();
  
  // Placed cones
  for (int i=0; i< staticCones.size(); ++i){
    Cone cone = staticCones.get( i );
    cone.draw();
  }
  
  
}

void mouseClicked(){
  
  Cone cone = new Cone();
  cone.setPosition(mouseX,height-mouseY,0);
  println( "x "+mouseX+" | y "+(height-mouseY) );
  cone.setVelocity(0,0,0);
  cone.setTriangles(40);
  cone.setRadius(mouseRadius);
  
  // Add it to the list
  staticCones.add( cone );
  
}

void mouseWheel(int delta) {
  float factor = 1 + delta * 0.01;
  mouseRadius *= factor;
  mouseRadius = max( mouseRadius, 1 );
  mouseRadius = min( mouseRadius, max(width, height) );
  mouseCone.setRadius( mouseRadius );
}

void keyPressed() {
  switch (key) {
   
      
    case CODED:
      switch(keyCode){

      }
  }
  
}

