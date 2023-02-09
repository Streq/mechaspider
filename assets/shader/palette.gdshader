shader_type canvas_item;
uniform int palette_size = 4;
uniform float offset : hint_range(0, 8, 1);
uniform sampler2D palette;
uniform float blue_index_offset = 0.0;


void fragment(){
	vec4 tex = texture(TEXTURE, UV);
	//used as index for the palette texture
	float blue_1 = tex.b;
	
	float palette_index = mod(blue_1 * (255.0) - blue_index_offset + offset+0.5,float(palette_size));
	float h_pixel_size = 1.0/float(palette_size);
	vec2 palette_pixel = vec2(palette_index*(h_pixel_size), 0.0);
	
	COLOR.rgba = texture(palette, palette_pixel);
	COLOR.a *= tex.a;
	
}