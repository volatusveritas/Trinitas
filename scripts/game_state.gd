# Autoload: GameState
extends Node

signal mode_changed(new_mode: Mode)

enum Mode {
    NORMAL,
    MOVE,
}

var mode := Mode.NORMAL : set = set_mode

func set_mode(new_mode: Mode) -> void:
    mode = new_mode
    mode_changed.emit(new_mode)

func get_mode_string() -> String:
    match mode:
        Mode.NORMAL:
            return "Normal"
        Mode.MOVE:
            return "Move"
        _:
            return "Unknown"
