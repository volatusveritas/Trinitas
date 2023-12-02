shader_type canvas_item;

uniform vec2 offset = vec2(0.0);
uniform vec2 zoom = vec2(1.0);

uniform float bar_size = 16.0;
uniform float bar_spacing = 48.0;
uniform float border_smoothness = 0.5;
uniform vec4 bullet_color: source_color;

uniform sampler2D screen_texture: hint_screen_texture;

void fragment() {
    float adj_bar_size = bar_size * zoom.x;
    float adj_bar_spacing = bar_spacing * zoom.x;
    float adj_border_smoothness = border_smoothness * zoom.x;
    float bar_jump = adj_bar_size + adj_bar_spacing;

    vec2 screen_size = 1.0 / SCREEN_PIXEL_SIZE;

    vec2 pixel_coord = (
        SCREEN_UV * screen_size
        - screen_size / 2.0
        + offset * zoom
    );

    vec2 bar_anchor = floor(pixel_coord / bar_jump) * bar_jump;
    vec2 bar_center = bar_anchor + (adj_bar_size - 1.0) / 2.0;
    float distance_to_center = distance(pixel_coord, bar_center);
    vec2 distance_to_anchor = pixel_coord - bar_anchor + 1.0;

    bool coord_in_bar = (
        distance_to_anchor.x <= adj_bar_size
        && distance_to_anchor.y <= adj_bar_size
    );

    if (coord_in_bar && distance_to_center <= adj_bar_size / 2.0) {
        float opacity = 1.0 - smoothstep(
            adj_bar_size / 2.0 - adj_border_smoothness,
            adj_bar_size / 2.0,
            distance_to_center
        );

        COLOR = vec4(bullet_color.rgb, bullet_color.a * opacity);
    }
    else {
        COLOR = texture(screen_texture, SCREEN_UV);
    }
}
