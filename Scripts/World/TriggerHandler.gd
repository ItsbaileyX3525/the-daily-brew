extends Node2D

@onready var triggers: Node2D = $"."
@onready var player: CharacterBody2D = $"../Player"

func triggerPlayer(body: Node2D, location_info: String):
	if body.name == "Player":
		player.entered_trigger(location_info)

func _ready() -> void:
	var children = triggers.get_children()
	for e in children:
		e.connect("body_entered", triggerPlayer.bind(e.get_meta("location")))
