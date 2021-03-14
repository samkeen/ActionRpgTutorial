shader_type canvas_item;
// https://www.youtube.com/watch?v=Ot9M0TlxApU&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a&index=22
uniform bool active = false;

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0,1.0,1.0, previous_color.a);
	vec4 new_color = previous_color;
	if(active){
		new_color = white_color;
	}
	COLOR = new_color;
}