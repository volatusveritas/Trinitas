extends TableItem

var value := 0

@onready var ValueLabel: Label = $CenterContainer/Elements/ValueLabel

func _ready() -> void:
    var plus_button: Button = $CenterContainer/Elements/PlusButton
    var minus_button: Button = $CenterContainer/Elements/MinusButton

    plus_button.pressed.connect(increase)
    minus_button.pressed.connect(decrease)

func _get_syncinfo() -> Dictionary:
    return {
        "pos": global_position,
        "value": value,
    }

func _apply_syncinfo(syncinfo: Dictionary) -> void:
    global_position = syncinfo["pos"]
    value = syncinfo["value"]
    update_label()

func update_label() -> void:
    ValueLabel.text = "%03d" % value

func increase() -> void:
    value += 1
    update_label()
    update_remote()

func decrease() -> void:
    value -= 1
    update_label()
    update_remote()
