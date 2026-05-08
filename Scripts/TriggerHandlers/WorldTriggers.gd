extends Node2D

@onready var triggers: Node2D = $"."
var trigger_types: Dictionary

func teleport_trigger(body: Node2D, location_info: String) -> void:
	if body.name != "Player":
		return
	
	body.teleport_trigger(location_info)

func sign_trigger(body: Node2D, signText: String) -> void:
	if body.name != "Player":
		return
		
	body.sign_trigger(signText)
	
func left_teleport_trigger(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	body.left_teleport_trigger()

func left_sign_trigger(body: Node2D) -> void:
	if body.name != "Player":
		return
		
	body.left_sign_trigger()

func _ready() -> void:
	trigger_types = {
		"body_enter" : {
			"teleport" : func(body:Node2D, trigger: Area2D): teleport_trigger(body, trigger.get_meta("location")),
			"sign" : func(body:Node2D, trigger: Area2D): sign_trigger(body, trigger.get_meta("signtext")),
		},
		"body_left" : {
			"teleport" : func(body:Node2D, trigger: Area2D): left_teleport_trigger(body),
			"sign" : func(body:Node2D, trigger: Area2D): left_sign_trigger(body),
		}
	}
	
	var children = triggers.get_children()
	for e in children:
		if not e.has_meta("triggertype"):
			continue
		e.connect("body_entered", trigger_types["body_enter"][e.get_meta("triggertype")].bind(e))
		e.connect("body_exited", trigger_types["body_left"][e.get_meta("triggertype")].bind(e))
