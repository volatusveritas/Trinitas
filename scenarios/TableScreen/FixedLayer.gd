class_name FixedLayer
extends CanvasLayer

@onready var blur_shader := $BlurShader as ColorRect

func _ready() -> void:
    var menu := $Menu as Menu
    var new_item_selector := $NewItemSelector as NewItemSelector
    var save_table_popup := $SaveTablePopup as SaveTablePopup
    var confirmation_popup := $ConfirmationPopup as ConfirmationPopup

    menu.visibility_changed.connect(_on_item_visibility_changed.bind(menu))
    new_item_selector.visibility_changed.connect(_on_item_visibility_changed.bind(new_item_selector))
    save_table_popup.visibility_changed.connect(_on_item_visibility_changed.bind(save_table_popup))
    confirmation_popup.visibility_changed.connect(_on_item_visibility_changed.bind(confirmation_popup))

func _on_item_visibility_changed(item: Control) -> void:
    blur_shader.visible = item.visible