


float widths[] = new float[60];
void setup()
{
 size(800, 600); 
 colorMode(HSB,1);
}


void draw()
{
  background(0.9);
  
  for (int i=0; i<60; ++i){
    widths[i] += random(0,1);
    fill(float(i)/60,0.5,1);
    rect(0, 10*i, widths[i], 10 );
  }
  

}
