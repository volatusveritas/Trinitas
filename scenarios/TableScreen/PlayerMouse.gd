class_name PlayerMouse
extends Control

const MOUSE_RADIUS := 10.5
const FONT_SIZE := 16.0

func _draw() -> void:
    draw_circle(Vector2.ZERO, MOUSE_RADIUS, Color.CORAL)
