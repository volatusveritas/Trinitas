class_name MoveHandle
extends Control

signal drag_started(target: TableItem)

var in_region: Callable = func(_point: Vector2) -> bool: return false

func _has_point(point: Vector2) -> bool:
    return in_region.call(point)

func _gui_input(input: InputEvent) -> void:
    if input.is_action_pressed("move_mode_drag"):
        drag_started.emit(get_parent())
