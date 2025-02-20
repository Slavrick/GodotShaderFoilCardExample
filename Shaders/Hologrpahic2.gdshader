shader_type canvas_item;


uniform vec2 mouse_position;
uniform vec2 sprite_position;


uniform float fov : hint_range(1, 179) = 90;
uniform bool cull_back = true;
uniform float y_rot : hint_range(-180, 180) = 0.0;
uniform float x_rot : hint_range(-180, 180) = 0.0;
uniform float inset : hint_range(0, 1) = 0.0;
varying flat vec2 o;
varying vec3 p;

uniform float tilt_amplitude = 30.0;

uniform vec3 foilcolor : source_color;
uniform float threshold = 0.1;
uniform float period = 0.003;
uniform float sin_threshold = 1.0;
uniform float effect_alpha_mult : hint_range(0,1) = 1.0;
uniform float direction : hint_range(0,1) = 0.5;

uniform sampler2D foil_mask;
uniform sampler2D gradient;
uniform sampler2D noise;

uniform float max_distance = 500.0;

varying smooth vec2 direction_to;

float inverse_lerp(float v, float a, float b){
	return (v - a) / (b - a);
}

mat2 to_rotated(float angle){
	return mat2(vec2(cos(angle),-sin(angle)),
				vec2(sin(angle),cos(angle)));
}

vec2 global_to_local(vec2 global_position){
	return vec2(0.0);
}

vec2 skew(){
	return vec2(0.0);
}

void vertex(){
	direction_to = mouse_position - sprite_position;
	float d = length( direction_to );
	float magnitude = min( 1.0 , d / max_distance);
	float angle = atan(direction_to.x,direction_to.y);
	float x_rota = abs(angle) / PI;
	float y_rota = abs(atan(direction_to.y,direction_to.x)) / PI;
	//y_rota = fract(y_rota + 0.5 );
	
	float sin_b = sin( (-y_rota + .5) * magnitude * (PI / 2.0) );
	float cos_b = cos( (-y_rota + .5) * magnitude * (PI / 2.0) );
	float sin_c = sin( (x_rota - .5) * magnitude * (PI / 2.0) );
	float cos_c = cos( (x_rota - .5) * magnitude * (PI / 2.0) );
	
	//float sin_b = sin(fract(angle + .5) );
	//float cos_b = cos(fract(angle + .5));
	//float sin_c = sin(x_rot / 180.0 * PI);
	//float cos_c = cos(x_rot / 180.0 * PI);
	
	mat3 inv_rot_mat;
	inv_rot_mat[0][0] = cos_b;
	inv_rot_mat[0][1] = 0.0;
	inv_rot_mat[0][2] = -sin_b;
	
	inv_rot_mat[1][0] = sin_b * sin_c;
	inv_rot_mat[1][1] = cos_c;
	inv_rot_mat[1][2] = cos_b * sin_c;
	
	inv_rot_mat[2][0] = sin_b * cos_c;
	inv_rot_mat[2][1] = -sin_c;
	inv_rot_mat[2][2] = cos_b * cos_c;
	
	
	float t = tan(fov / 360.0 * PI);
	p = inv_rot_mat * vec3((UV - 0.5), 0.5 / t);
	float v = (0.5 / t) + 0.5;
	p.xy *= v * inv_rot_mat[2].z;
	o = v * inv_rot_mat[2].xy;

	VERTEX += (UV - 0.5) / TEXTURE_PIXEL_SIZE * t * (1.0 - inset);
}

void fragment() {
	if (cull_back && p.z <= 0.0) discard;
	vec2 uv = (p.xy / p.z).xy - o;
	COLOR = texture(TEXTURE, uv + 0.5);
	COLOR.a *= step(max(abs(uv.x), abs(uv.y)), 0.5);
}

void nothing(){
	//vec2 st = UV;
	//st *= to_rotated(direction);
	//float mouse_distance = distance(VERTEX.x,mouse_position.x);
	//
	//float circled = 1.0 - distance( fract(st * 20.0), vec2(.5));
	//circled = step( .75, circled) * inverse_lerp( circled , .75 , 1.0);
	//circled /= 10.0;
	//
	//float sin_distance = ( sin( distance(VERTEX.x,mouse_position.x) * period) + 1.0 ) / 2.0;
	//
	//if( texture(foil_mask,UV).r > threshold && sin_distance > 0.0 ){
	//	sin_distance += circled;
	//	sin_distance = sin(sin_distance);
	//	float dd = (sin_distance - sin_threshold) / (1.0 - sin_threshold);
	//	dd += circled;
	//	dd *= PI;
	//	dd = sin(dd);
	//	dd = sin_distance;
	//	vec3 gradient_color = texture(gradient,vec2( (sin_distance - sin_threshold) / (1.0 - sin_threshold), 0.0)).rgb;
	//	gradient_color = texture(gradient,vec2( dd , 0.0)).rgb;
	//	COLOR.rgb = mix(texture(TEXTURE,UV).rgb, gradient_color, (sin_distance - sin_threshold) / 2.0 / (1.0 - sin_threshold));
	//}
	////COLOR.rg = VERTEX / 100.0;
	//COLOR.rg = direction_to;
	
}





// uniform bool something
// if someting
// ...
// else something
// ...


// bool something = UV.x < .5
// if someting
// ...
// else something
// ...


// if a > b
//	something *= 5

//something += 4 * something * step(b,a)


