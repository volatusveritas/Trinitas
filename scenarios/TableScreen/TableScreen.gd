extends Control

@onready var NewItemSelector: NewItemSelector = $NewItemSelector
@onready var ItemStage: ItemStage = $ItemStage
@onready var TableItems: TableItems = $TableItems

func _ready() -> void:
    NewItemSelector.item_requested.connect(ItemStage.set_target)
    ItemStage.item_confirmed.connect(TableItems.create_item)
