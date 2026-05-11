extends Control

@onready var inventory_items: GridContainer = $Inventory/MarginContainer/GridContainer
@onready var hold_icon: TextureRect = $PlayerFrame/Holding/MarginContainer/Icon
@onready var exp_bar: ProgressBar = $PlayerFrame/Frame/EXP
@onready var exp_amount_label: Label = $PlayerFrame/Frame/EXPAmount
@onready var inventory: Panel = $Inventory

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		inventory.visible = !inventory.visible

func exp_updated(exp_amount: float, exp_needed: float, level: int) -> void:
	exp_amount_label.text = "%s / %s" % [roundi(exp_amount), roundi(exp_needed)]
	var curr_percent: int = roundi((exp_amount / exp_needed) * 100)
	exp_bar.value = curr_percent

func try_equip(item_name: String) -> void:
	if not Player.hold(item_name):
		print("Failed to hold item")
		return
	
	var item_data: Array = Player.get_held_item()
	hold_icon.texture = item_data[1]

func _ready() -> void:
	var tmp = inventory_items.get_children()
	for e in tmp:
		if not e.has_signal("wants_to_equip"):
			continue
		e.connect("wants_to_equip", try_equip)

	Player.connect("exp_updated", exp_updated)
	var exp = Player.get_exp()
	exp_updated(exp[0], exp[1], exp[2])
