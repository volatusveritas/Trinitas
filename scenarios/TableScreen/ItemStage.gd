class_name ItemStage
extends Control

signal item_confirmed(item: Control)

const NEW_ITEM_OPACITY := 0.8

var target_item: Control = null

func _physics_process(_delta: float) -> void:
    if target_item == null:
        return

    Controls.center_on_mouse(target_item)

func _input(event: InputEvent) -> void:
    if target_item == null or not event is InputEventMouseButton:
        return

    if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        remove_child(target_item)
        item_confirmed.emit(target_item)
        target_item = null

func set_target_item(scene: PackedScene) -> void:
    var new_item: Control = scene.instantiate()
    new_item.modulate.a = NEW_ITEM_OPACITY

    add_child(new_item)
    target_item = new_item
