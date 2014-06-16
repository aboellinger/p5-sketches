


int N = 20000;
float[][] vtx = new float[N][];

void setup(){
  size(500,500);
  colorMode(HSB,1);
  
  vtx[0] = new float[]{height/2, width/2};
  for (int i=1; i<vtx.length; i++){
    float x = constrain( 
                vtx[i-1][0] + random(-1, 1),
                  0, width );
    float y = constrain( 
                vtx[i-1][1] + random(-1, 1),
                  0, height );
    vtx[i] = new float[]{x, y};
  }
}

void draw(){
  background(0);
  stroke(1,0.1);
  for (int i=1; i<vtx.length; i++){
    float t = ( float(i) + millis()*10 )/N;
    t = t-floor(t);
    stroke(t,1,1,0.1);
    line(vtx[i-1][0],vtx[i-1][1],vtx[i][0],vtx[i][1]);
  }
}
