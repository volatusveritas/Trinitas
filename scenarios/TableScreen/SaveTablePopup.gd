class_name SaveTablePopup
extends Control

func _unhandled_key_input(event: InputEvent) -> void:
    if visible and event.is_action_pressed("ui_cancel"):
        visible = false
        get_tree().root.set_input_as_handled()

func _gui_input(_event: InputEvent) -> void:
    accept_event()