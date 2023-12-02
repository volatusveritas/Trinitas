extends Control

@onready var ip_field: LineEdit = $MenuItems/ConnectInfo/IPField
@onready var connect_button: Button = $MenuItems/ConnectInfo/ConnectButton
@onready var host_button: Button = $MenuItems/HostButton
@onready var error_label: ErrLabel = $ErrorLabel

const PORT := 20251

func _ready() -> void:
    host_button.pressed.connect(_on_host_button_pressed)
    connect_button.pressed.connect(_on_connect_button_pressed)

    multiplayer.connection_failed.connect(func():
        error_label.show_message("Connected")
    )

    multiplayer.connected_to_server.connect(func():
        get_tree().change_scene_to_packed(GameData.SCENE_TABLE)
    )

    ip_field.grab_focus()

func _process(_delta: float) -> void:
    verify_ip_field()

func verify_ip_field() -> void:
    connect_button.disabled = ip_field.text.is_empty()

func create_peer(host: bool) -> void:
    var peer := ENetMultiplayerPeer.new()

    var peer_err: Error

    if host:
        peer_err = peer.create_server(PORT)
    else:
        peer_err = peer.create_client(ip_field.text, PORT)

    if peer_err != OK:
        if host:
            error_label.show_message("ERROR WHILE CREATING HOST")
        else:
            error_label.show_message("ERROR WHILE CREATING CLIENT")

        return

    multiplayer.multiplayer_peer = peer

    if host:
        get_tree().change_scene_to_packed(GameData.SCENE_TABLE)

func _on_host_button_pressed() -> void:
    create_peer(true)

func _on_connect_button_pressed() -> void:
    create_peer(false)
