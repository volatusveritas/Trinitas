extends Control

@onready var NewItemSelector: NewItemSelector = $NewItemSelector
@onready var ItemStage: ItemStage = $ItemStage
@onready var TableItems: Control = $TableItems

func _ready() -> void:
    NewItemSelector.item_requested.connect(ItemStage.set_target)
    ItemStage.item_confirmed.connect(func(path: String, pos: Vector2) -> void:
        self.place_item.rpc(path, pos)
    )

@rpc("any_peer", "call_local", "reliable")
func place_item(path: String, pos: Vector2) -> void:
    var scene := load(path)
    var node: Control = scene.instantiate()

    TableItems.add_child(node)
    node.global_position = pos
