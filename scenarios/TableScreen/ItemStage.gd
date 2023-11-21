class_name ItemStage
extends Control

signal item_confirmed(path: String, pos: Vector2)

const PLACEHOLDER_OPACITY := 0.8

var target_path := ""
var placeholder_item: Control = null

func _physics_process(_delta: float) -> void:
    if placeholder_item == null:
        return

    Controls.center_on_mouse(placeholder_item)

func _input(event: InputEvent) -> void:
    if placeholder_item == null or not event is InputEventMouseButton:
        return

    if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        var pos := placeholder_item.global_position

        remove_child(placeholder_item)
        placeholder_item.queue_free()
        placeholder_item = null

        item_confirmed.emit(target_path, pos)

func create_placeholder() -> void:
    var scene := load(target_path)
    placeholder_item = scene.instantiate()

    add_child(placeholder_item)

    placeholder_item.modulate.a = PLACEHOLDER_OPACITY

func set_target(path: String) -> void:
    target_path = path
    create_placeholder()
