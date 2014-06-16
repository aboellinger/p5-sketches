

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float threshold_degree;

varying vec4 vertColor;


float threshold_value(float x){
	// if x=={0.0,0.5,1.0} returns {0.0,0.5,1.0}
	if (x<0.5){
		return pow( 2*x, threshold_degree ) * 0.5;
	}else{
		return 1 - pow( 2*(1-x), threshold_degree ) * 0.5;
	}
}

void main() {
  // Outputting pixel color (interpolated across triangle)
float x = vertColor.x;
x = threshold_value( x );
  gl_FragColor = vec4( x,x,x,1.0 );
}