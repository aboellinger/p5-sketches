class Cone{
  
  // Parameter fields
  PVector p;
  PVector v;
  
  float rad;
  int tri;
  
  
  
  boolean isDyn = true;
  
  
  
  // Internal fields
  PVector vtx[];
  color col[];
  
  Cone(){
    return;
  }
  
  // Recompute the cone mesh vertices
  void recomputeVertices(){
    vtx = new PVector[tri+2];
    col = new color[tri+2];
    
    vtx[0] = new PVector(0,0,-1);
    col[0] = color(1);
    
    float phi_step = 2*PI / tri;
    for (int i=0; i<=tri; ++i){
      float phi = i * phi_step;
      vtx[i+1] = new PVector(
                          cos(phi) * rad,
                          sin(phi) * rad,
                          0 );
      
      col[i+1] = color(0);
    
    }
        
  }
  
  void draw(){
    
    pushMatrix();
    
    // Translate to cone position
    translate(p.x, p.y, p.z);
    // Draw the vertices
    beginShape(TRIANGLE_FAN);
    noStroke();
    for (int i=0; i<vtx.length; ++i){
      fill(col[i]);
      vertex(vtx[i].x, vtx[i].y, vtx[i].z);
    }
    endShape();//

    popMatrix();
    
  }
  
  // Sets the cone triangle number
  void setTriangles(int t){
    tri = max(3, t);
    recomputeVertices();
  }  
  // Sets the cone radius
  void setRadius(float r){
    rad = max(0, r);
    recomputeVertices();
  }
  
  void setDynamic(boolean bool){
    isDyn = bool;
  }
  
  void setPosition(PVector pos){
    p = pos;
  }
  void setPosition(float x, float y, float z){
    p = new PVector(x, y, z);
  }  
  
  void setVelocity(float x, float y, float z){
    v = new PVector(x, y, z);
  }
  void setVelocity(PVector vel){
    v = vel;
  }  
  
  
}
