extends Control

@onready var new_item_selector: NewItemSelector = $FixedLayer/NewItemSelector
@onready var item_stage: ItemStage = $ItemStage
@onready var table_items: TableItems = $TableItems
@onready var infinite_background: ColorRect = $BackgroundLayer/InfiniteBackground
@onready var camera: Camera2D = $Camera

func _ready() -> void:
    new_item_selector.item_requested.connect(item_stage.set_target)
    item_stage.item_confirmed.connect(table_items.create_item)

func _physics_process(_delta: float) -> void:
    (infinite_background.material as ShaderMaterial).set_shader_parameter(
        "offset",
        camera.position
    )

func _input(input: InputEvent) -> void:
    if not input is InputEventKey:
        return

    if input.pressed and input.keycode == KEY_ESCAPE:
        var focused := get_tree().root.gui_get_focus_owner()

        if focused != null:
            focused.release_focus()
