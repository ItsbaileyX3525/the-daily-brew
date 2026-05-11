extends Node

signal data_loaded
var is_data_loaded: bool = false

var default_playerData: Dictionary = {
	"charname" : "None",
	"firstPlay" : "true",
	"maxHealth" : 100,
	"neededExp" : 100,
	"exp" : 0,
	"level": 1,
	"playerInventory" : [ #[item, slot_pos]
		["wakame", 0],
		["heal_shroom", 1]
	],
	"current_quest": "None",
}

var playerData: Dictionary

func save_data():
	var game_file := FileAccess.open("user://playerData.json", FileAccess.WRITE)
	
	var json_string := JSON.stringify(playerData)
	game_file.store_line(json_string)
	
func load_data() -> Dictionary:
	var loaded_data: Dictionary
	if not FileAccess.file_exists("user://playerData.json"):
		return default_playerData
	
	var game_save := FileAccess.get_file_as_string("user://playerData.json")

	loaded_data = JSON.parse_string(game_save)

	return loaded_data
	
func _ready() -> void:
	load_data()
	playerData = load_data().duplicate_deep()
	print(playerData)
	data_loaded.emit()
	is_data_loaded = true
