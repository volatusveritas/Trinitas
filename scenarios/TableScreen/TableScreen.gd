extends Control

@onready var NewItemSelector: NewItemSelector = $FixedLayer/NewItemSelector
@onready var ItemStage: ItemStage = $ItemStage
@onready var TableItems: TableItems = $TableItems

func _ready() -> void:
    NewItemSelector.item_requested.connect(ItemStage.set_target)
    ItemStage.item_confirmed.connect(TableItems.create_item)

func _input(input: InputEvent) -> void:
    if not input is InputEventKey:
        return

    if input.pressed and input.keycode == KEY_ESCAPE:
        var focused := get_tree().root.gui_get_focus_owner()

        if focused != null:
            focused.release_focus()
