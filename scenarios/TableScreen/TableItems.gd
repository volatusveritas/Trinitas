class_name TableItems
extends Control

func _ready() -> void:
    if multiplayer.is_server():
        multiplayer.peer_connected.connect(func(id: int) -> void:
            populate.rpc_id(id, build_item_map())
        )

        return

func add_item(path: String, syncinfo: Dictionary) -> TableItem:
    var scene := load(path)
    var table_item: TableItem = scene.instantiate()

    add_child(table_item)

    table_item._path = path
    table_item._apply_syncinfo(syncinfo)

    return table_item

func create_item(path: String, syncinfo: Dictionary) -> void:
    var table_item := add_item(path, syncinfo)
    table_item.name = str(table_item.get_instance_id())
    receive_item.rpc(path, syncinfo, table_item.name)

@rpc("any_peer", "call_remote", "reliable")
func receive_item(path: String, syncinfo: Dictionary, id: String) -> void:
    var table_item := add_item(path, syncinfo)
    table_item.name = id

func build_item_map() -> Dictionary:
    var item_map := {}

    for item in get_children():
        item_map[item.name] = {
            "path": item._path,
            "syncinfo": item._get_syncinfo(),
        }

    return item_map

@rpc("any_peer", "call_remote", "reliable")
func populate(item_map: Dictionary) -> void:
    for id in item_map:
        var item := add_item(item_map[id]["path"], item_map[id]["syncinfo"])
        item.name = id
