class_name NewItemSelector
extends Control

signal item_requested(path: String)

@onready var ItemButtons: VBoxContainer = $Elements/ScrollContainer/ItemButtons

func _ready() -> void:
    item_requested.connect(func(_path): visible = false)

    add_item(
        "Basic Counter",
        "res://scenes/table_items/Counter/Counter.tscn"
    )

    add_item(
        "Paper Note",
        "res://scenes/table_items/SharedWriting/SharedWriting.tscn"
    )

    add_item(
        "Token",
        "res://scenes/table_items/Token/Token.tscn"
    )

func _unhandled_input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("add_item"):
        visible = not visible

func add_item(item_name: String, path: String) -> void:
    var item_button := Button.new()

    ItemButtons.add_child(item_button)

    item_button.text = item_name
    item_button.pressed.connect(func(): item_requested.emit(path))
