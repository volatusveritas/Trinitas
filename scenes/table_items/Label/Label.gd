extends TableItem

@onready var line: LineEdit = $Line

func _get_syncinfo() -> Dictionary:
    return {
        "pos": global_position,
        "text": line.text,
    }

func _apply_syncinfo(syncinfo: Dictionary) -> void:
    global_position = syncinfo["pos"]
    line.text = syncinfo["text"]
