shader_type canvas_item;

const float QUALITY = 8.0;
const float DIRECTIONS = 16.0;

uniform sampler2D screen_texture: hint_screen_texture;
uniform float pixel_distance = 5.0;

void fragment()
{
    vec2 radius_scaling = pixel_distance * SCREEN_PIXEL_SIZE;
    vec4 blur_color = texture(screen_texture, SCREEN_UV);

    for (float d = 0.0; d < PI * 2.0; d += PI * 2.0 / DIRECTIONS) {
        for (float i = 1.0 / QUALITY; i < 1.0; i += 1.0 / QUALITY) {
            vec2 offset = vec2(cos(d), sin(d)) * radius_scaling;
            blur_color += texture(screen_texture, SCREEN_UV + offset * i);
        }
    }

    blur_color /= (QUALITY - 1.0) * DIRECTIONS + 1.0;

    COLOR = blur_color;
}