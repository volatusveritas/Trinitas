shader_type canvas_item;

uniform vec2 offset;
uniform float bar_size = 16.0;
uniform float bar_spacing = 48.0;
uniform float border_smoothness = 0.5;
uniform vec4 bullet_color: source_color;

uniform sampler2D screen_texture: hint_screen_texture;

void fragment() {
    float bar_jump = bar_size + bar_spacing;

    vec2 pixel_coord = SCREEN_UV / SCREEN_PIXEL_SIZE + offset;
    vec2 bar_anchor = floor(pixel_coord / bar_jump) * bar_jump;
    vec2 bar_center = bar_anchor + (bar_size - 1.0) / 2.0;
    float distance_to_center = distance(pixel_coord, bar_center);
    vec2 distance_to_anchor = pixel_coord - bar_anchor + 1.0;

    bool coord_in_bar = (
        distance_to_anchor.x <= bar_size
        && distance_to_anchor.y <= bar_size
    );

    if (coord_in_bar && distance_to_center <= bar_size / 2.0) {
        float opacity = 1.0 - smoothstep(
            bar_size / 2.0 - border_smoothness,
            bar_size / 2.0,
            distance_to_center
        );

        COLOR = vec4(bullet_color.rgb, bullet_color.a * opacity);
    }
    else {
        COLOR = texture(screen_texture, SCREEN_UV);
    }
}
