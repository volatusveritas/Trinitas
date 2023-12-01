extends Camera2D

const SPEED := 1200
const MIN_ZOOM := 0.5
const MAX_ZOOM := 1.75

var movement_direction := Vector2.ZERO
var zoom_direction := 0.0
var zoom_acceleration_rate := 3.0
var zoom_deceleration_rate := 0.85

var _infinidots_shader: ShaderMaterial = null

func _physics_process(delta: float) -> void:
    position += movement_direction * SPEED * delta / zoom.x

    var target_zoom: float = clamp(zoom.x + zoom_direction, MIN_ZOOM, MAX_ZOOM)
    var zoom_update := (target_zoom - zoom.x) * zoom_acceleration_rate
    var zoom_step := zoom_update * delta

    zoom.x += zoom_step
    zoom.y += zoom_step

    zoom_direction *= zoom_deceleration_rate

    if _infinidots_shader:
        _infinidots_shader.set_shader_parameter(
            "offset",
            get_screen_center_position()
        )

func _unhandled_input(input: InputEvent) -> void:
    if get_tree().root.gui_get_focus_owner() != null:
        movement_direction = Vector2.ZERO
        return

    movement_direction = Input.get_vector(
        "camera_left",
        "camera_right",
        "camera_up",
        "camera_down"
    )

    if not input is InputEventMouseButton:
        return

    if input.button_index == MOUSE_BUTTON_WHEEL_UP:
        zoom_direction = 1.0
    elif input.button_index == MOUSE_BUTTON_WHEEL_DOWN:
        zoom_direction = -1.0
