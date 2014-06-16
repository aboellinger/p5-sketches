
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D textureSampler;

uniform sampler2D ker;
uniform vec2 ker_res;
uniform float ker_sum;

uniform vec2 resolution;

uniform float col_factor;
uniform float col_mode;


void main( void ) {
	vec2 position  = gl_FragCoord.xy;

	vec2 p  = ( position /*+ d*/ ) / resolution.xy;
	

	//vec3 col = texture2D(textureSampler, p).xyz;

	//vec3 col = vec3(0,0,0);
	vec3 col = vec3(1,1,1);
	//
	int width = ker_res.x;
	for( int i=0; i<ker_res.x*ker_res.y; ++i ){

		vec2 kp = vec2( (i%width) / ker_res.x , 
				 	    (i/width) / ker_res.y );
		vec3 spl_ker = texture2D(ker, kp).xyz;

		vec2 d  = vec2(  (i%width) - 0.5*ker_res.x , 
				 	     (i/width) - 0.5*ker_res.y );
		vec2 p  = ( position + d ) / resolution.xy;
		vec3 spl_tex = texture2D(textureSampler, p).xyz;

		/*/
		vec3 spl = vec3( 	spl_ker.x * spl_tex.x ,
					  	 	spl_ker.y * spl_tex.y ,
					  	 	spl_ker.z * spl_tex.z );//*/

		vec3 spl = vec3( 	spl_tex.x / spl_ker.x ,
					  	 	spl_tex.y / spl_ker.y ,
					  	 	spl_tex.z / spl_ker.z );

		//col +=  spl / ker_sum;
		//col = max(col, spl);
		col = min(col, spl);

	}//*/

	col *= col_factor;

	if(col_mode>0.5){
		col = vec3(
					(col.x<0)?  1 : 0 ,
					(col.x>1)?  1 : 0 ,
					(col.x==0)? 1 : 0 );
	}



	gl_FragColor = vec4( col, 1);
}