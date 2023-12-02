class_name ItemStage
extends Control

signal item_confirmed(path: String, syncinfo: Dictionary)

const PLACEHOLDER_OPACITY := 0.8

var target_path := ""
var placeholder_item: TableItem = null

func _physics_process(_delta: float) -> void:
    if placeholder_item == null:
        return

    Controls.center_on_mouse(placeholder_item)

func _input(event: InputEvent) -> void:
    if placeholder_item == null or not event is InputEventMouseButton:
        return

    if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
        var syncinfo := placeholder_item._get_syncinfo()

        reset()

        item_confirmed.emit(target_path, syncinfo)

func reset() -> void:
    if placeholder_item == null:
        return

    remove_child(placeholder_item)
    placeholder_item.queue_free()
    placeholder_item = null

func create_placeholder() -> void:
    var scene := load(target_path)
    placeholder_item = scene.instantiate()

    add_child(placeholder_item)

    placeholder_item.modulate.a = PLACEHOLDER_OPACITY

    var cover := Control.new()
    cover.mouse_filter = Control.MOUSE_FILTER_STOP
    cover.set_anchors_preset(PRESET_FULL_RECT)

    placeholder_item.add_child(cover)

func set_target(path: String) -> void:
    target_path = path
    create_placeholder()
