extends Control

@onready var MouseHub: MouseHub = $MouseHub

func _ready() -> void:
    share_initial_mouse_pos()

    if multiplayer.is_server():
        multiplayer.peer_connected.connect(share_mouse_list)

func _physics_process(delta: float) -> void:
    share_new_mouse_pos()

func share_new_mouse_pos() -> void:
    MouseHub.update_mouse.rpc(get_local_mouse_position())

func share_initial_mouse_pos() -> void:
    if multiplayer.is_server():
        return

    MouseHub.new_mouse.rpc(get_local_mouse_position())

func share_mouse_list(id: int) -> void:
    var mouse_map := { "1": get_local_mouse_position() }

    for child in MouseHub.get_children():
        mouse_map[child.name] = child.position

    receive_mouse_list.rpc_id(id, mouse_map)

@rpc("any_peer", "call_remote", "reliable")
func receive_mouse_list(mouse_map: Dictionary) -> void:
    for id in mouse_map:
        var player_mouse := PlayerMouse.new()

        MouseHub.add_child(player_mouse)

        player_mouse.name = id
        player_mouse.position = mouse_map[id]
