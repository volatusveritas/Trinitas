extends Control

@onready var mode_label: Label = $ModeLabel

func _ready() -> void:
    GameState.mode_changed.connect(update_label)

func update_label(_new_mode: GameState.Mode) -> void:
    mode_label.text = GameState.get_mode_string()
