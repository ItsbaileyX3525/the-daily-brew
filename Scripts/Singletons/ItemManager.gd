extends Node

var items: Dictionary = {
	"cheese" : [preload("uid://be7txba0hvcad"), "yummy cheese."],
	"wakame" : [preload("uid://bi8ytow230swv"), "A medicinal herb, may make health-related potions stronger."],
	"heal_shroom" : [preload("uid://cdan488efdf5j"), "A healing shroom, often heals people when concentrated."]
}

func get_item_texture(item_string) -> Resource:
	return items[item_string][0]

func get_item_description(item_string) -> String:
	return items[item_string][1]
