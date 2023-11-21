class_name Controls
extends Node

static func center_on(obj: Control, pos: Vector2) -> void:
    obj.global_position = Vector2(
        pos.x - obj.size.x / 2,
        pos.y - obj.size.y / 2,
    )

static func center_on_mouse(obj: Control) -> void:
    center_on(obj, obj.get_global_mouse_position())
