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

    var save_button: Button = $FixedLayer/SessionButtons/SaveButton
    save_button.pressed.connect(save_table)
    var load_button: Button = $FixedLayer/SessionButtons/LoadButton
    load_button.pressed.connect(load_table)

func _process(_delta: float) -> void:
    if Input.is_action_just_released("move_mode_drag"):
        drag_target = null
        
    if Input.is_action_just_pressed("drop_focus"):
        var focused := get_tree().root.gui_get_focus_owner()
        
        if focused != null:
            focused.release_focus()

func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("enter_normal_mode"):
        GameState.mode = GameState.Mode.NORMAL
    elif event.is_action_pressed("enter_move_mode"):
        GameState.mode = GameState.Mode.MOVE
    elif event.is_action_pressed("cancel_item_placement"):
        item_stage.reset()

func _input(input: InputEvent) -> void:
    var drag_input = input as InputEventMouseMotion

    if drag_input == null or drag_target == null:
        return

    drag_target.global_position += drag_input.relative / camera.zoom.x
    drag_target.update_remote()

func save_table() -> void:
    var file = FileAccess.open("user://save.trinitable", FileAccess.WRITE)

    if file == null:
        return

    var contents := table_items.build_item_map()

    file.store_var(contents)

func load_table() -> void:
    var file = FileAccess.open("user://save.trinitable", FileAccess.READ)

    if file == null:
        return

    var contents: Dictionary = file.get_var()

    table_items.populate(contents)
