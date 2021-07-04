shader_type canvas_item;

uniform float blue = 1.0; // you can assign a default value to uniforms

void fragment(){
  COLOR = texture(TEXTURE, UV); //read from texture
  COLOR.b = blue;
}