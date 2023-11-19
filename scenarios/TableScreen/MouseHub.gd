class_name MouseHub
extends Control

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
