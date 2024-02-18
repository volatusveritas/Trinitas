class_name StatusLabel
extends Label

@export var fade_time := 1.0 # Measured in seconds
@export var display_time := 3.0 # Measured in seconds

var fade_in_tween: Tween = null
var fade_out_tween: Tween = null
var display_timer: Timer = null

func _ready() -> void:
    modulate = Color.TRANSPARENT

    display_timer = Timer.new()
    display_timer.name = "DisplayTimer"
    display_timer.wait_time = display_time
    display_timer.one_shot = true
    display_timer.timeout.connect(_on_display_timer_timeout)
    add_child(display_timer)

func animate_show() -> void:
    reset()

    fade_in_tween = create_tween()
    fade_in_tween.tween_property(
        self,
        "modulate",
        Color.WHITE,
        fade_time
    )

    fade_in_tween.finished.connect(_on_fade_in_tween_finished)

func display(message: String) -> void:
    text = message
    animate_show()

func info(message: String) -> void:
    display(message)

func warning(message: String) -> void:
    display(message)

func error(message: String) -> void:
    display(message)

func reset() -> void:
    if fade_in_tween and fade_in_tween.is_running():
        fade_in_tween.stop()

    if fade_out_tween and fade_out_tween.is_running():
        fade_out_tween.stop()

    if not display_timer.is_stopped():
        display_timer.stop()

    modulate = Color.TRANSPARENT

func _on_fade_in_tween_finished() -> void:
    display_timer.start()

func _on_display_timer_timeout() -> void:
    fade_out_tween = create_tween()
    fade_out_tween.tween_property(
        self,
        "modulate",
        Color.TRANSPARENT,
        fade_time
    )
