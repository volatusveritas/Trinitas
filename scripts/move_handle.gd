class_name MoveHandle
extends Control

signal drag_started(target: TableItem)

var in_region: Callable = func(_point: Vector2) -> bool: return false

func _ready() -> void:
    GameState.mode_changed.connect(_on_GameState_mode_changed)

    set_anchors_preset(Control.PRESET_FULL_RECT)
    mouse_default_cursor_shape = Control.CURSOR_MOVE
    update_mode_filter()

func _has_point(point: Vector2) -> bool:
    return in_region.call(point)

func _gui_input(input: InputEvent) -> void:
    if input.is_action_pressed("move_mode_drag"):
        drag_started.emit(get_parent())

func update_mode_filter() -> void:
    if GameState.mode == GameState.Mode.MOVE:
        mouse_filter = Control.MOUSE_FILTER_STOP
    else:
        mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_GameState_mode_changed(_new_mode: GameState.Mode) -> void:
    update_mode_filter()
