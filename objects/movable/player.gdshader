shader_type canvas_item;

uniform float hp;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	if (UV.y > hp/100.f){
		tex = vec4(255.f, 0, 0, tex.a);
	}
	COLOR = tex;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
