class_name ErrLabel
extends Label

const EXHIBITION_TIME := 2.0
const FADE_OUT_TIME := 1.0

func show_message(msg: String) -> void:
    text = msg
    modulate.a = 1.0

    get_tree().create_timer(EXHIBITION_TIME).timeout.connect(func():
        var tween := get_tree().create_tween()
        tween.tween_property(self, "modulate:a", 0.0, FADE_OUT_TIME)
    )
