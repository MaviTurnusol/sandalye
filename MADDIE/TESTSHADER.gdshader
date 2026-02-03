shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform sampler2D noise;

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR =textureLod(screen_texture,SCREEN_UV,0.0);
	COLOR = texture(noise,UV);
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
