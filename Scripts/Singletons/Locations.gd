extends Node

const valid_locations: Dictionary = {
	"PlayerHouse" : preload("uid://kjf5gn5n0mai"),
	"World" :  preload("uid://nesq618xk3u"),
	"Shop" : preload("uid://bkxl6rs1mgyhv")
}

func check_location(location: String):
	if valid_locations.has(location):
		return true
	else:
		return false

func switch_location(location: String):
	get_tree().change_scene_to_packed(valid_locations[location])
