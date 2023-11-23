extends TextEdit

func _gui_input(event: InputEvent) -> void:
    if event is InputEventKey:
        if not event.pressed:
            if event.keycode == KEY_ESCAPE:
                if has_focus():
                    release_focus()
