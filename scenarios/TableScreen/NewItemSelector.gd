class_name NewItemSelector
extends Control

signal item_requested(scene: PackedScene)

@onready var ItemButtons: VBoxContainer = $Elements/ScrollContainer/ItemButtons

func _ready() -> void:
    item_requested.connect(func(_scene): visible = false)

    add_item(
        "Roach Killer",
        preload("res://scenes/table_items/RoachKillerCard.tscn")
    )

func toggle() -> void:
    visible = not visible

func add_item(name: String, scene: PackedScene) -> void:
    var item_button := Button.new()
    item_button.text = name
    item_button.pressed.connect(func(): item_requested.emit(scene))

    ItemButtons.add_child(item_button)