
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D textureSampler;

uniform vec2 resolution;

void main( void ) {
	vec2 position  = gl_FragCoord.xy;



	vec2 p  = 	position                 / resolution.xy;
	vec2 pN = ( position + vec2( 0,-1) ) / resolution.xy;
	vec2 pS = ( position + vec2( 0, 1) ) / resolution.xy;
	vec2 pE = ( position + vec2( 1, 0) ) / resolution.xy;
	vec2 pW = ( position + vec2(-1, 0) ) / resolution.xy;


	vec3 c  = texture2D(textureSampler, p ).xyz;
	vec3 cN = texture2D(textureSampler, pN).xyz;
	vec3 cS = texture2D(textureSampler, pS).xyz;
	vec3 cE = texture2D(textureSampler, pE).xyz;
	vec3 cW = texture2D(textureSampler, pW).xyz;

	vec3 col = 0.25 * ( cN + cS + cE + cW );
	//vec3 col = c;

	gl_FragColor = vec4( col.xyz, 1);
}