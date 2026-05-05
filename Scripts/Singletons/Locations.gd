extends Node

const valid_locations: Dictionary = {
	"PlayerHouse" : preload("res://Scenes/Shop.tscn"),
	
}

func check_location(location: String):
	if valid_locations.has(location):
		return true
	else:
		return false
