shader_type canvas_item;

uniform int wire_wobbles;
uniform float wobble_relative_height;
uniform float wire_height;
uniform bool left;
uniform bool right;
uniform bool top;
uniform bool bottom;

float wire_function(float argument){
	return (sin(argument * float(wire_wobbles) * 2. * PI) * wobble_relative_height + 1.)/2.;
}


void fragment() {
	COLOR.a = 0.;
	if (UV.y >  wire_function(UV.x) - wire_height){
		if (UV.y <  wire_function(UV.x) + wire_height){
			if (left && UV.x <= 0.5){
				COLOR.a = 1.;
			}
			if (right && UV.x >= 0.5){
				COLOR.a = 1.;
			}
		}
	}
	if (UV.x >  wire_function(UV.y) - wire_height){
		if (UV.x <  wire_function(UV.y) + wire_height){
			if (top && UV.y <= 0.5){
				COLOR.a = 1.;
			}
			if (bottom && UV.y >= 0.5){
				COLOR.a = 1.;
			}
		}
	}
}
