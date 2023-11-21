extends Control

@onready var IPField: LineEdit = $MenuItems/ConnectInfo/IPField
@onready var ConnectButton: Button = $MenuItems/ConnectInfo/ConnectButton
@onready var HostButton: Button = $MenuItems/HostButton
@onready var ErrorLabel: ErrLabel = $ErrorLabel

const PORT := 20251

func _ready() -> void:
    HostButton.pressed.connect(_on_HostButton_pressed)
    ConnectButton.pressed.connect(_on_ConnectButton_pressed)

    multiplayer.connection_failed.connect(func():
        ErrorLabel.show_message("Connected")
    )

    multiplayer.connected_to_server.connect(func():
        get_tree().change_scene_to_packed(GameData.SCENE_TABLE)
    )

func _process(_delta: float) -> void:
    verify_ip_field()

func verify_ip_field() -> void:
    ConnectButton.disabled = IPField.text.is_empty()

func create_peer(host: bool) -> void:
    var peer := ENetMultiplayerPeer.new()

    var peer_err: Error

    if host:
        peer_err = peer.create_server(PORT)
    else:
        peer_err = peer.create_client(IPField.text, PORT)

    if peer_err != OK:
        if host:
            ErrorLabel.show_message("ERROR WHILE CREATING HOST")
        else:
            ErrorLabel.show_message("ERROR WHILE CREATING CLIENT")

        return

    multiplayer.multiplayer_peer = peer

    if host:
        get_tree().change_scene_to_packed(GameData.SCENE_TABLE)

func _on_HostButton_pressed() -> void:
    create_peer(true)

func _on_ConnectButton_pressed() -> void:
    create_peer(false)
