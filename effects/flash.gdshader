shader_type canvas_item;

void fragment() {
	// Called for every pixel the material is visible on.
	//受到伤害特效
	COLOR = vec4(1.0,1.0,1.0,texture(TEXTURE,UV).a);
}