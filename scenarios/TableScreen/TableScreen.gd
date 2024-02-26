extends Control

var drag_target: TableItem = null

const TABLES_PATH := "tables"

@onready var new_item_selector := $FixedLayer/NewItemSelector as NewItemSelector
@onready var item_stage := $ItemStage as ItemStage
@onready var table_items := $TableItems as TableItems
@onready var camera := $Camera as Camera2D
@onready var confirmation_popup := $FixedLayer/ConfirmationPopup as ConfirmationPopup
@onready var save_table_popup := $FixedLayer/SaveTablePopup as Control

func _ready() -> void:
    new_item_selector.selection_started.connect(item_stage.reset)
    new_item_selector.item_requested.connect(item_stage.set_target)
    item_stage.item_confirmed.connect(table_items.create_item)
    table_items.drag_started.connect(func(target: TableItem):
        drag_target = target
    )

    var menu := $FixedLayer/Menu as Menu

    var save_table_button := $FixedLayer/Menu/Elements/Buttons/SaveTableButton as Button
    var _load_table_button := $FixedLayer/Menu/Elements/Buttons/LoadTableButton as Button

    save_table_button.pressed.connect(func() -> void:
        menu.hide()
        save_table_popup.show()
    )

    var background: ColorRect = $BackgroundLayer/Background
    camera._infinidots_shader = background.material as ShaderMaterial

    camera.moved.connect(func(offset: Vector2):
        if drag_target == null:
            return

        drag_target.global_position += offset
        drag_target.update_remote()
    )

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

func get_table_path(save_name: String) -> String:
    return "user://%s/%s.trinitas_table" % [TABLES_PATH, save_name]

func save_table(save_name: String, status_label: StatusLabel) -> void:
    var dir_access := DirAccess.open("user://")

    if not dir_access.dir_exists(TABLES_PATH):
        # TODO: make this message more useful
        status_label.error("Could not write to file.")
        dir_access.make_dir(TABLES_PATH)

    var file_path := get_table_path(save_name)

    if FileAccess.file_exists(file_path):
        save_table_popup.hide()

        var answer := await confirmation_popup.confirm(
            "A table with this save_name already exists. Overwrite?"
        )

        save_table_popup.show()

        if not answer:
            return

    var file = FileAccess.open(file_path, FileAccess.WRITE)

    if file == null:
        status_label.error("Could not write to file.")
        return

    var contents := table_items.build_item_map()

    file.store_var(contents)
    status_label.info("Table saved.")

func load_table(save_name: String, status_label: StatusLabel) -> void:
    var file_path := get_table_path(save_name)
    var file = FileAccess.open(file_path, FileAccess.READ)

    if file == null:
        status_label.error("Could not read file.")
        return

    var contents: Dictionary = file.get_var()

    table_items.populate(contents)
    status_label.info("Table loaded.")
