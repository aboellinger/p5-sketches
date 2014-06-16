#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D textureSampler;

uniform vec2 resolution;
uniform vec2 mouse;

void main(void) {
    vec2 p = gl_FragCoord.xy / resolution.xy;
    vec2 m = mouse.xy / resolution.xy;

    //float b = sqrt(p.x*p.x + p.y*p.y);
    //vec3 col = vec3(p, b);

    p.y = 1-p.y;
    p.x /= 3;
    vec3 bea = texture2D(textureSampler, p).xyz;
    
    p.x += 1/3.;
    vec3 occ = texture2D(textureSampler, p).xyz;

    p.x += 1/3.;
    vec3 dep = texture2D(textureSampler, p).xyz;

    vec3 col = bea;
    col = col * ( 1-m.x + occ*m.x );
    col = col * ( 1-m.y + dep*m.y );

    gl_FragColor = vec4(col,1);
}