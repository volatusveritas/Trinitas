class_name ConfirmationPopup
extends Control

signal answered()

@onready var confirmation_label := $Box/Elements/ConfirmationLabel as Label

var last_answer := false

func _ready() -> void:
    ($Box/Elements/Buttons/ProceedButton as Button).pressed.connect(func():
        last_answer = true
        hide()
        answered.emit()
    )

    ($Box/Elements/Buttons/CancelButton as Button).pressed.connect(func():
        last_answer = false
        hide()
        answered.emit()
    )

func confirm(query: String) -> bool:
    confirmation_label.text = query
    show()

    await answered

    return last_answer
