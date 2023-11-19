class_name MouseHub
extends Control

func _ready() -> void:
    if multiplayer.is_server():
        multiplayer.peer_connected.connect(share_mouse_list)
        return

    new_mouse.rpc(get_local_mouse_position())

func _physics_process(delta: float) -> void:
    update_mouse.rpc(get_local_mouse_position())

func share_mouse_list(id: int) -> void:
    var mouse_map := { "1": get_local_mouse_position() }

    for child in get_children():
        mouse_map[child.name] = child.position

    receive_mouse_list.rpc_id(id, mouse_map)

@rpc("any_peer", "call_remote", "reliable")
func receive_mouse_list(mouse_map: Dictionary) -> void:
    for id in mouse_map:
        var player_mouse := PlayerMouse.new()

        add_child(player_mouse)

        player_mouse.name = id
        player_mouse.position = mouse_map[id]

@rpc("any_peer", "call_remote", "reliable")
func new_mouse(pos: Vector2) -> void:
    var id := multiplayer.get_remote_sender_id()
    var player_mouse := PlayerMouse.new()
    
    add_child(player_mouse)

    player_mouse.position = pos
    player_mouse.name = str(id)

@rpc("any_peer", "call_remote", "unreliable")
func update_mouse(new_pos: Vector2) -> void:
    var id := multiplayer.get_remote_sender_id()
    var player_mouse := get_node(str(id)) as PlayerMouse
    player_mouse.position = new_pos
