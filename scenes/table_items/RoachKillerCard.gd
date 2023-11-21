extends TableItem

func _get_syncinfo() -> Dictionary:
    return {
        "pos": global_position,
    }

func _apply_syncinfo(syncinfo: Dictionary) -> void:
    global_position = syncinfo["pos"]
