shader_type canvas_item;

uniform sampler2D texture_albedo;
uniform vec3 foilcolor : source_color;
uniform float threshold = 0.1;
uniform float effect_alpha_mult : hint_range(0,1) = 1.0;
uniform float direction : hint_range(0,1) = 0.5;
uniform sampler2D gradient;
uniform sampler2D noise;

uniform float max_distance = 500.0;
uniform vec2 mouse_position;

vec2 global_to_local(vec2 global_position){
	return vec2(0.0);
}

void fragment() {
	//vec2 mp = global_to_local(mouse_position);
	if( distance(texture(TEXTURE,UV).rgb, foilcolor) < threshold){
		float f =  clamp( 1.0 - (distance(mouse_position,VERTEX) / max_distance) , 0.0, 1.0 );
		vec4 noise_value = texture(noise,UV) * f;
		COLOR.rgb = mix(texture(TEXTURE,UV).rgb, texture(gradient,vec2(f,0.0)).rgb + noise_value.rgb, f * 0.5);
	}
	
	//mp.x += sin(TIME);
	//mp.x += cos(TIME);
	//vec2 base_uv = UV;
	////vec4 albedo_tex = texture(texture_albedo,UV);
	//vec4 noise_tex = texture(noise,base_uv);
	//vec4 gradient_tex = texture(gradient, vec2((0.25+(mp.y*direction*2.0-mp.x*(1.0-direction)*2.0)/2.0+(UV.y*direction+UV.x*(1.0-direction))/2.0), 0.0));
	//
	//if(distance(COLOR.rgb,foilcolor) < threshold){
	//	COLOR.rgb = mix(COLOR.rgb, gradient_tex.rgb*(noise_tex.rgb*2.0), (effect_alpha_mult-length(COLOR))*gradient_tex.a*effect_alpha_mult);
	//}
}
