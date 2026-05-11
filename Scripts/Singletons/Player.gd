extends Node

var holding: String
var curr_exp: float
var needed_exp: float
var curr_level: int

signal exp_updated(new_amount: float, new_amount_needed: float, level: int)

func data_loaded() -> void:
	curr_level = DataManager.playerData["level"]
	curr_exp = DataManager.playerData["exp"]
	needed_exp = DataManager.playerData["neededExp"]
	exp_updated.emit(curr_exp, needed_exp, curr_level)

func load_data() -> void:
	if not DataManager.is_data_loaded:
		DataManager.connect("data_loaded", data_loaded)
		print("Waiting for data to load")
	else:
		print("Data already loaded")
		data_loaded()

func _ready() -> void:
	load_data()

func get_held_item() -> Array:
	var item_texture: Resource = ItemManager.get_item_texture(holding)
	var item_data = [holding, item_texture]
	return item_data

func hold(item: String) -> bool:
	holding = item
	return true

func get_exp() -> Array:
	var tmp: Array = [
		curr_exp,
		needed_exp,
		curr_level
	]
	return tmp
