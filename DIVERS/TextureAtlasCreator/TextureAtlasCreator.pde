
// Met des images de meme dimension les unes a la suite des autres

PImage[] imgs;
int w,h,ww,hh,nw;
int[] w0,h0;

void setup(){
  w = h = 0;
  
  
  int startIndex = 1;
  int endIndex = 21;
  int nImgs = endIndex - startIndex + 1;
  
  String path = "angelo/";
  String prefix = "CFE_VG_014.";
  String ext = ".png";
  
  imgs = new PImage[nImgs];
  w0 = new int[nImgs];
  h0 = new int[nImgs];
  ww = 170*2;
  hh = 250*2;
  nw = 6;
  w = nw*ww;
  h = ( (nImgs/nw) + ((nImgs%nw==0)?0:1) )*hh;
  
  
  for (int i=0; i + startIndex <= endIndex; ++i){
    println("processing image "+i+" of "+(endIndex - startIndex));
    
    String index = String.format("%03d",i + startIndex);
    String imgPath = path + prefix + index + ext;
    
    imgs[i] = loadImage(imgPath,"png");
    
    imgs[i].resize(ww,hh);
    
    w0[i] = (i%nw)*ww;
    h0[i] = (i/nw)*hh;
  }
  

  

  
  PGraphics pg = createGraphics(w,h,JAVA2D);
  pg.beginDraw();
  println("w : "+w+"  h : "+h);
  for (int i=0; i<nImgs; ++i){
    pg.image(imgs[i],w0[i],h0[i]);
  }
  pg.endDraw();
  pg.save("angelo.png");
  image(pg,0,0);
  
  
  
}

void draw(){}

void mouseClicked(){
  color c = imgs[0].get(mouseX,mouseY);
  println(" a:"+alpha(c)+" r:"+red(c)+" g:"+green(c)+" b:"+blue(c));
}
