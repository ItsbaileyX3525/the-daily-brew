extends Node

const valid_locations: Dictionary = {
	"PlayerHouse" : preload("res://Scenes/Shop.tscn"),
	"World" : preload("res://Scenes/World.tscn")
}

func check_location(location: String):
	if valid_locations.has(location):
		return true
	else:
		return false

func switch_location(location: String):
	get_tree().change_scene_to_packed(valid_locations[location])
