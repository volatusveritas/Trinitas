extends TableItem

@onready var line: LineEdit = $Line

func _ready() -> void:
    line.text_changed.connect(_on_line_text_changed)

func _get_syncinfo() -> Dictionary:
    return {
        "pos": global_position,
        "text": line.text,
        "caret": line.caret_column,
    }

func _apply_syncinfo(syncinfo: Dictionary) -> void:
    global_position = syncinfo["pos"]
    line.text = syncinfo["text"]
    line.caret_column = syncinfo["caret"]

func _on_line_text_changed(_new_text: String) -> void:
    update_remote()
