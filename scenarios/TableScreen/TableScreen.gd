extends Control

@onready var NewItemSelector: NewItemSelector = $NewItemSelector
@onready var ItemStage: ItemStage = $ItemStage
@onready var TableItems: Control = $TableItems

func _ready() -> void:
    NewItemSelector.item_requested.connect(ItemStage.set_target_item)
    ItemStage.item_confirmed.connect(place_item)

func place_item(item: Control) -> void:
    TableItems.add_child(item)
    item.modulate.a = 1.0
    Controls.center_on_mouse(item)
