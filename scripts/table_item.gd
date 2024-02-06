class_name TableItem
extends Control

var _path := ""

func _has_point(point: Vector2) -> bool:
    return Hitboxes.rectangle(self, point)

func _in_move_region(point: Vector2) -> bool:
    return _has_point(point)

func _get_syncinfo() -> Dictionary:
    return {}

func _apply_syncinfo(_syncinfo: Dictionary) -> void:
    pass

func update_remote() -> void:
    update_local.rpc(_get_syncinfo())

@rpc("any_peer", "call_local", "reliable")
func update_local(syncinfo: Dictionary) -> void:
    _apply_syncinfo(syncinfo)
