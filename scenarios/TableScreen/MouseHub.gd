class_name MouseHub
extends Control

func _ready() -> void:
    multiplayer.peer_disconnected.connect(destroy_mouse)

    if multiplayer.is_server():
        multiplayer.peer_connected.connect(func(id: int):
            populate.rpc_id(id, build_mouse_map())
        )

        return

    new_mouse.rpc(get_local_mouse_position())

func _physics_process(_delta: float) -> void:
    update_mouse.rpc(get_local_mouse_position())

func build_mouse_map() -> Dictionary:
    var mouse_map := {
        str(multiplayer.get_unique_id()): get_local_mouse_position()
    }

    for child in get_children():
        mouse_map[child.name] = child.position

    return mouse_map

func destroy_mouse(id: int) -> void:
    var mouse := get_node(str(id))

    remove_child(mouse)
    mouse.queue_free()

func create_mouse(mouse_name: String, pos: Vector2) -> void:
    var player_mouse := PlayerMouse.new()

    add_child(player_mouse)

    player_mouse.name = mouse_name
    player_mouse.position = pos

@rpc("any_peer", "call_remote", "reliable")
func populate(mouse_map: Dictionary) -> void:
    for id in mouse_map:
        create_mouse(id, mouse_map[id])

@rpc("any_peer", "call_remote", "reliable")
func new_mouse(pos: Vector2) -> void:
    create_mouse(str(multiplayer.get_remote_sender_id()), pos)

@rpc("any_peer", "call_remote", "unreliable")
func update_mouse(new_pos: Vector2) -> void:
    var id := multiplayer.get_remote_sender_id()
    var player_mouse := get_node(str(id)) as PlayerMouse
    player_mouse.position = new_pos
