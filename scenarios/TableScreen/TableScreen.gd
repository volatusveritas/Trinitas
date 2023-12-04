extends Control

var drag_target: TableItem = null

@onready var new_item_selector: NewItemSelector = $FixedLayer/NewItemSelector
@onready var item_stage: ItemStage = $ItemStage
@onready var table_items: TableItems = $TableItems
@onready var camera: Camera2D = $Camera

func _ready() -> void:
    new_item_selector.selection_started.connect(item_stage.reset)
    new_item_selector.item_requested.connect(item_stage.set_target)
    item_stage.item_confirmed.connect(table_items.create_item)
    var background: ColorRect = $BackgroundLayer/Background
    camera._infinidots_shader = background.material as ShaderMaterial

    table_items.drag_started.connect(func(target: TableItem):
        drag_target = target
    )

    camera.moved.connect(func(offset: Vector2):
        if drag_target == null:
            return

        drag_target.global_position += offset
        drag_target.update_remote()
    )

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("enter_normal_mode"):
        GameState.mode = GameState.Mode.NORMAL
    elif Input.is_action_just_pressed("enter_move_mode"):
        GameState.mode = GameState.Mode.MOVE

    if Input.is_action_just_pressed("cancel_item_placement"):
        item_stage.reset()

        var focused := get_tree().root.gui_get_focus_owner()

        if focused != null:
            focused.release_focus()

    if Input.is_action_just_released("move_mode_drag"):
        drag_target = null

func _input(input: InputEvent) -> void:
    var drag_input = input as InputEventMouseMotion

    if drag_input == null or drag_target == null:
        return

    drag_target.global_position += drag_input.relative / camera.zoom.x
    drag_target.update_remote()
