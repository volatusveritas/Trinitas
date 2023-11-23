extends TableItem

@onready var Writing: TextEdit = $Writing

func _ready() -> void:
    Writing.text_changed.connect(_on_Writing_text_changed)

func _get_syncinfo() -> Dictionary:
    return {
        "pos": global_position,
        "text": Writing.text,
        "caret": Vector2(Writing.get_caret_column(), Writing.get_caret_line())
    }

func _apply_syncinfo(syncinfo: Dictionary) -> void:
    global_position = syncinfo["pos"]
    Writing.text = syncinfo["text"]
    Writing.set_caret_line(syncinfo["caret"].y)
    Writing.set_caret_column(syncinfo["caret"].x)

func _on_Writing_text_changed() -> void:
    update_remote()
