shader_type canvas_item;

uniform int columns = 4;
uniform int rows = 4;


uniform int frame = 0;//// Do not edit

void fragment() {
	vec2 uv = UV;

	float col = float(frame % columns);
	float row = float(frame / columns);

	uv.x = (uv.x + col) / float(columns);
	uv.y = (uv.y + row) / float(rows);

	vec4 tex = texture(TEXTURE, uv);
	COLOR = tex;
}
