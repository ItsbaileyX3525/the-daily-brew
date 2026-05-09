extends Node2D

var trigger_types: Dictionary
@onready var triggers: Node2D = $"."

func teleport_trigger(body: Node2D, location_info: String) -> void:
	if body.name != "Player":
		return
	
	body.teleport_trigger(location_info)
	
func left_teleport_trigger(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	body.left_teleport_trigger()

func _ready() -> void:
	trigger_types = {
		"body_enter" : {
			"teleport" : func(body:Node2D, trigger: Area2D): teleport_trigger(body, trigger.get_meta("location")),
		},
		"body_left" : {
			"teleport" : func(body:Node2D, trigger: Area2D): left_teleport_trigger(body),
		}
	}
	
	var children = triggers.get_children()
	for e in children:
		print(e.name)
		if not e.has_meta("triggertype"):
			print("skipped: ", e.name)
			continue
		print("binded: ", e.name)
		e.connect("body_entered", trigger_types["body_enter"][e.get_meta("triggertype")].bind(e))
		e.connect("body_exited", trigger_types["body_left"][e.get_meta("triggertype")].bind(e))
