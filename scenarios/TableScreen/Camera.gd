extends Camera2D

const SPEED := 700

var movement_direction := Vector2.ZERO

func _physics_process(delta: float) -> void:
    position += movement_direction * SPEED * delta

func _unhandled_input(_input: InputEvent) -> void:
    if get_tree().root.gui_get_focus_owner() != null:
        movement_direction = Vector2.ZERO
        return

    movement_direction = Input.get_vector(
        "camera_left",
        "camera_right",
        "camera_up",
        "camera_down"
    )
