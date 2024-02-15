class_name SaveTablePopup
extends Control

signal save_requested(name: String, status_label: StatusLabel)

@onready var name_input := $Box/Elements/NameInput as LineEdit

func _ready() -> void:
    var save_button := $Box/Elements/SaveButton as Button
    var status_label := $Box/StatusLabel as StatusLabel

    name_input.text_changed.connect(func(new_name: String) -> void:
        save_button.disabled = len(new_name) == 0
    )

    save_button.pressed.connect(func() -> void:
        save_requested.emit(name_input.text, status_label)
    )

func _input(event: InputEvent) -> void:
    if visible and event.is_action_pressed("drop_focus"):
        clear()
        get_tree().root.set_input_as_handled()

func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            clear()

func clear() -> void:
    hide()
    name_input.text = ""
