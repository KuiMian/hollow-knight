shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	COLOR.rgba = vec4(1.0, 1.0, 1.0, texture_color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
