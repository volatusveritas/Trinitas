class_name TableItems
extends Control

signal drag_started(target: TableItem)

func _ready() -> void:
    if multiplayer.is_server():
        multiplayer.peer_connected.connect(func(id: int) -> void:
            populate.rpc_id(id, build_item_map())
        )

func get_move_handle_mode_filter(mode: GameState.Mode) -> Control.MouseFilter:
    if mode == GameState.Mode.MOVE:
        return Control.MOUSE_FILTER_STOP

    return Control.MOUSE_FILTER_IGNORE

func add_item(path: String, syncinfo: Dictionary) -> TableItem:
    var scene := load(path)
    var table_item: TableItem = scene.instantiate()

    add_child(table_item)

    table_item._path = path
    table_item._apply_syncinfo(syncinfo)

    var move_handle := MoveHandle.new()
    table_item.add_child(move_handle)

    move_handle.mouse_filter = get_move_handle_mode_filter(GameState.mode)

    GameState.mode_changed.connect(func(new_mode: GameState.Mode) -> void:
        move_handle.mouse_filter = get_move_handle_mode_filter(new_mode)
    )

    move_handle.set_anchors_preset(Control.PRESET_FULL_RECT)
    move_handle.mouse_default_cursor_shape = Control.CURSOR_MOVE
    move_handle.in_region = table_item._in_move_region

    move_handle.drag_started.connect(func(target: TableItem):
        move_atop.rpc(target.name)
        drag_started.emit(target)
    )

    return table_item

func create_item(path: String, syncinfo: Dictionary) -> void:
    var table_item := add_item(path, syncinfo)
    table_item.name = str(table_item.get_instance_id())
    receive_item.rpc(path, syncinfo, table_item.name)

@rpc("any_peer", "call_local", "reliable")
func move_atop(name_id: String) -> void:
    move_child(get_node(name_id), -1)

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
