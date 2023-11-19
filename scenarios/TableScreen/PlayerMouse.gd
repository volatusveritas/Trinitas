class_name PlayerMouse
extends Control

const CIRCLE_RADIUS := 4.0
const FONT_SIZE := 16.0
const TEXT_MARGIN := -4.0

func _draw() -> void:
    var font := get_theme_default_font()
    var font_size := get_theme_default_font_size()

    var text_width := font.get_string_size(
        name,
        HORIZONTAL_ALIGNMENT_CENTER,
        -1,
        font_size
    )

    var text_pos := Vector2(-text_width.x / 2, -text_width.y - TEXT_MARGIN)

    draw_circle(Vector2.ZERO, CIRCLE_RADIUS, Color.CORAL)
    draw_string(font, text_pos, name)
