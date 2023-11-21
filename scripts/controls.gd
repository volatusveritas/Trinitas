# Autoloaded: Controls
extends Node

static func center_on_mouse(obj: Control) -> void:
    var mouse_pos = obj.get_global_mouse_position()

    obj.global_position = Vector2(
        mouse_pos.x - obj.size.x / 2,
        mouse_pos.y - obj.size.y / 2,
    )
