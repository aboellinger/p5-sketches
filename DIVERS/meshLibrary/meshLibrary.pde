import megamu.mesh.*;

size(800,600,P2D);
colorMode(HSB,1);

float[][] points = new float[100][2];
      
for( int i=0; i<points.length; ++i){
  points[i][0] = sqrt(random(0, 1))*width;
  points[i][1] = sqrt(random(0, 1))*height;
}

Voronoi myVoronoi = new Voronoi( points );

MPolygon[] myRegions = myVoronoi.getRegions();

noStroke();
for(int i=0; i<myRegions.length; i++)
{
  // an array of points
  float[][] regionCoordinates = myRegions[i].getCoords();
  
  fill(float(i)/myRegions.length,0.8,0.8);
  myRegions[i].draw(this); // draw this shape
}

Delaunay myDelaunay = new Delaunay( points );
float[][] myEdges = myDelaunay.getEdges();

strokeWeight(2);
for(int i=0; i<myEdges.length; i++)
{
  float startX = myEdges[i][0];
  float startY = myEdges[i][1];
  float endX = myEdges[i][2];
  float endY = myEdges[i][3];
  float length = sqrt(sq(startX-endX)+sq(startY-endY));
  stroke(0.33*(1 - length/300),1,1);
  line( startX, startY, endX, endY );
}
