shader_type canvas_item;

uniform vec2 offset;
uniform float bar_size = 16.0;
uniform float bar_spacing = 48.0;
uniform vec4 bullet_color: source_color;

uniform sampler2D screen_texture: hint_screen_texture;

float get_first_edge(float pos) {
     float bar_jump = bar_size + bar_spacing;
     return floor(pos / bar_jump) * bar_jump;
}

bool axis_in_bar(float pos) {
    return pos - get_first_edge(pos) + 1.0 <= bar_size;
}

bool coord_in_bar(vec2 coord) {
    return axis_in_bar(coord.x) && axis_in_bar(coord.y);
}

vec2 get_circle_center(vec2 coord) {
    float edge_offset = (bar_size - 1.0) / 2.0;

    return vec2(
        get_first_edge(coord.x) + edge_offset,
        get_first_edge(coord.y) + edge_offset
    );
}

bool coord_in_bar_circle(vec2 coord) {
    return distance(get_circle_center(coord), coord) <= (bar_size / 2.0);
}

void fragment() {
    vec2 pixel_coord = SCREEN_UV / SCREEN_PIXEL_SIZE + offset;

    if (coord_in_bar(pixel_coord) && coord_in_bar_circle(pixel_coord)) {
        COLOR = bullet_color;
    }
    else {
        COLOR = texture(screen_texture, SCREEN_UV);
    }
}
