void setup(){
 size(200,200);
 colorMode(RGB,1); 
}

void draw(){
 stroke(0.4);
 line(0,height/2, width,height/2);
  
 float a = 1000;
 float b = 0.01;
  
 stroke(1,0,0);
 float x0 = 0;
 float y0 = height/2;
 for(float x=0;x<width;x++){
   float y = a*(1/x) + height/2;
   line(x0,y0,x,y);
   x0 = x;
   y0 = y;
 }
 
 stroke(0,1,0);
 x0 = 0;
 y0 = height/2;
 for(float x=0;x<width;x++){
   float y = b*x*(x-100) + height/2;
   line(x0,y0,x,y);
   x0 = x;
   y0 = y;
 }
 
 stroke(0,0,1);
 x0 = 0;
 y0 = height/2;
 for(float x=0;x<width;x++){
   float y = a/x + b*x*(x-100) + height/2;
   line(x0,y0,x,y);
   x0 = x;
   y0 = y;
 }
}
