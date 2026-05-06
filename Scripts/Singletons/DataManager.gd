extends Node

var items: Dictionary = {
	"cheese" : preload("uid://be7txba0hvcad"),
	
}

var default_playerData: Dictionary = {
	"charname" : "none inputted",
}

var default_inventory: Array = [
	[],
]

var playerInventory: Array = [
	["cheese", 2]
]

var playerData: Dictionary

func save_data():
	return
	
func load_data():
	
	return
	
func _ready() -> void:
	load_data()
	playerData = default_playerData.duplicate(true)
	print(playerData.charname)
