class_name Menu
extends Control

func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed("toggle_menu"):
        visible = not visible
