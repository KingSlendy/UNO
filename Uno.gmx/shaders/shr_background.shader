attribute vec3 in_Position;

varying vec2 fragCoord;

void main() {
    vec4 object_space_pos = vec4(in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    fragCoord = in_Position.xy;
}
//######################_==_YOYO_SHADER_MARKER_==_######################@~uniform vec2 resolution;
uniform float time;

varying vec2 fragCoord;

float hash(vec2 uv) {
    return fract(45656.65 * sin(dot(uv, vec2(45.45, 786.4))));
}

float map(vec2 uv) {
    vec2 i = floor(uv);
    	uv = 2.0 * fract(uv) - 1.0;
    float r = float(mod(i.x + i.y, 2.0) == 0.0);
    float d = max(abs(uv.x), abs(uv.y));
    	
    return (r == 0.0) ? d : 1.0 - d;
}

void main() {
    vec2 uv = (2.0 * fragCoord.xy - resolution.xy) / resolution.y;
    vec3 col = vec3(0.0);
    	uv *=5.0;
    float m = map(uv);
    	
    vec2 o = vec2(0.01, 0.0);
    vec3 n = normalize(vec3(m - map(uv + o.xy), m - map(uv + o.yx), -o.x));
    vec3 l = normalize(vec3(cos(time * 1.2), 1.0 + sin(time * 0.5), -1.1));
    vec3 v = normalize(vec3(uv, 1.0));
    	
    float diff = max(dot(n, l), 0.0);
    float spec = pow(max(dot(n, normalize(l - v)), 0.0), 8.0);
    vec3 backColor = vec3(1.0, 1.0, 0.0);
    	
    	col +=vec3(backColor.r, backColor.g * 0.5, backColor.b) * m * 0.5;
    	col +=vec3(backColor.r, backColor.g * 0.1, backColor.b) * diff * 0.5;
    	col +=vec3(backColor.r, backColor.g, backColor.b) * spec * 0.5;
    	
    gl_FragColor = vec4(col, 1.0);
}
