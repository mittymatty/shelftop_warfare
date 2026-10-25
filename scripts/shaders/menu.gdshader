shader_type canvas_item;

void vertex() {
	UV.x += TIME * .025; 
	UV.y += TIME * -.025;
}
