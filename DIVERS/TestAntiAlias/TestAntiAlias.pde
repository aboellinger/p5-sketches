
// \\srv-bin\bin\tools\ffmpeg\bin\ffmpeg.exe -r 24 -i "E:\Antoine\Processing\FastVoronoi\VoronoiAnim%03d.png" -f mov -vcodec targa -y E:\Antoine\Processing\FastVoronoi\normalPerturb_0.002.mov 

import javax.media.opengl.*;
import processing.opengl.*;


final int N_FRAMES_TO_RECORD = 0;

final int n_particles = 100;
PVector[] positions = new PVector[n_particles];
PVector[] positions0 = new PVector[n_particles];
PVector[] velocities = new PVector[n_particles];

float coneAngle = 1;
float coneDepth = 1000;
int coneTriangles = 30;
float cornerThreshold = 0.1;

float tx, ty, tz, rx, ry, rz, scl;

float dataAmp = 0.75;
float noiseFreq = 1.5;
float noiseOff = 0;
float noiseOffScale = 0.005;
float velocityFactor = 0.1;
float normalPerturbation = -0.002;

int blurAmount=10;

int viewMode = 3;






Cone cone;

void setup(){
  colorMode(RGB, 1.0);
  size(512,512, OPENGL);
  background(32);
  
  
  cone = new Cone();
  cone.setPosition(new PVector(0,0,0));
  cone.setVelocity(new PVector(0,0,0));
  cone.setTriangles(10);
  cone.setRadius(50);
  
  noCursor();
}

void draw(){
  
  GL gl = ((PGraphicsOpenGL)g).gl;
  // Disable antialiasing and blending, to ensure that color values are not interpolated.
  // This way we have an equivalence color = cone = voronoi cell
  gl.glDisable(GL.GL_MULTISAMPLE);
  gl.glDisable(GL.GL_LINE_SMOOTH);
  gl.glDisable(GL.GL_BLEND);
  
  background(32);
  
  ortho(0, width, 0, height, -1, 1000);
  camera(0,0,-10,0,0,0,0,-1,0);
  noLights();
  pushMatrix();
  // Afficher le repère de l'espace
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
   //*/
  
  cone.setPosition(new PVector(mouseX,height-mouseY,0));
  cone.draw();
  
  
  popMatrix();
  return;
  ///////////////////////////////////////////////////////////////////////////

  
}


final float MULT_FACTOR = 1.05;
final float DIV_FACTOR = 0.95;
void keyPressed() {
  switch (key) {
    
    // Blur amount
    case 'b':
      blurAmount -= 1;
      print("\nblurAmount: "+blurAmount);
      break;
    case 'B':
      blurAmount += 1;
      print("\nblurAmount: "+blurAmount);
      break;//
      
    // cone Angle
    case 'a':
      coneAngle *= DIV_FACTOR;
      print("\nconeAngle: "+coneAngle);
      break;
    case 'A':
      coneAngle *= MULT_FACTOR;
      print("\nconeAngle: "+coneAngle);
      break;//
      
    // View
    case '1':
      viewMode = 1;
      print("\nviewMode: "+viewMode);
      break;
    case '2':
      viewMode = 2;
      print("\nviewMode: "+viewMode);
      break;
    case '3':
      viewMode = 3;
      print("\nviewMode: "+viewMode);
      break;
    case '4':
      viewMode = 4;
      print("\nviewMode: "+viewMode);
      break;
      
      
    // DataAmp
    case 'm':
      dataAmp *= DIV_FACTOR;
      print("\ndataAmp: "+dataAmp);
      break;
    case 'M':
      dataAmp *= MULT_FACTOR;
      print("\ndataAmp: "+dataAmp);
      break;//*/
      
    
    // Noise Frequency
    case 'f':
      noiseFreq *= DIV_FACTOR;
      print("\nnoiseFreq: "+noiseFreq);
      break;
    case 'F':
      noiseFreq *= MULT_FACTOR;
      print("\nnoiseFreq: "+noiseFreq);
      break;//*/
    // Noise Offset
    case 'o':
      noiseOff -= 0.01;
      print("\nnoiseOff: "+noiseOff);
      break;
    case 'O':
      noiseOff += 0.01;
      print("\nnoiseOff: "+noiseOff);
      break;//*/
    // Normal perturbation
    case 'p':
      normalPerturbation -= 0.0001;
      print("\nnormalPerturbation: "+normalPerturbation);
      break;
    case 'P':
      normalPerturbation += 0.0001;
      print("\nnormalPerturbation: "+normalPerturbation);
      break;//*/
      
    // cone Depth
    case 'd':
      coneDepth *= DIV_FACTOR;
      print("\nconeDepth: "+coneDepth);
      break;
    case 'D':
      coneDepth *= MULT_FACTOR;
      print("\nconeDepth: "+coneDepth);
      break;
      
    // cone triangles
    case 'T':
      ++coneTriangles;
      print("\nconeTriangles: "+coneTriangles);
      break;
    case 't':
      coneTriangles = max(--coneTriangles, 3);
      print("\nconeTriangles: "+coneTriangles);
      break;    
      
    // particles Velocity
    case 'V':
      velocityFactor *= MULT_FACTOR;
      print("\nvelocityFactor: "+velocityFactor);
      break;
    case 'v':
      velocityFactor *= DIV_FACTOR;
      print("\nvelocityFactor: "+velocityFactor);
      break;
  
     // corner Threshold
    case 'C':
      cornerThreshold *= MULT_FACTOR;
      print("\ncornerThreshold: "+cornerThreshold);
      break;
    case 'c':
      cornerThreshold *= DIV_FACTOR;
      print("\ncornerThreshold: "+cornerThreshold);
      break;


    // Noise Offset
    case 'x':
      tx -= 1;
      print("\ntx: "+tx);
      break;
    case 'X':
      tx += 1;
      print("\ntx: "+tx);
      break;//*/    
    case 'y':
      ty -= 1;
      print("\nty: "+ty);
      break;
    case 'Y':
      ty += 1;
      print("\nty: "+ty);
      break;//*/    
    case 'z':
      tz -= 1;
      print("\ntz: "+tz);
      break;
    case 'Z':
      tz += 1;
      print("\ntz: "+tz);
      break;//*/
      
      
    case CODED:
      switch(keyCode){

      }
  }
  
  printInfo();
}

void printInfo(){
  println("-");
}