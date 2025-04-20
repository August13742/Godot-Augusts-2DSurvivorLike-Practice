shader_type canvas_item;

uniform vec3 target_colour = vec3(1.0,1.0,1.0);
uniform float lerp_percent:hint_range(0.0,1.0);
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 texture_colour = texture(TEXTURE,UV);
	//vec2 example = texture_colour.ar;
	vec4 final_colour = mix(texture_colour,vec4(target_colour,texture_colour.a),lerp_percent);
	COLOR = final_colour;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
