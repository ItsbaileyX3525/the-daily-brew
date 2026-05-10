extends Control

var SHOP = load("uid://bkxl6rs1mgyhv")

@onready var fade: ColorRect = $Fade
@onready var inventory: Control = $Inventory
var can_interact: bool = false
@onready var can_interact_timer: Timer = $CanInteract

func _ready() -> void:
	#npc_encounter.wait_time = randf_range(2,10)
	await get_tree().create_timer(.2).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate", Color.hex(0xffffff00), .6)
	await tween.finished
	tween.kill() #Just ensure it's been removed from the tree
	tween = null

func _on_shop_hover_mouse_entered() -> void:
	if not can_interact:
		return
	if SHOP == null:
		print("Error: SHOP scene failed to load!")
		return
	get_tree().change_scene_to_packed(SHOP)

func _on_inventory_hover_mouse_entered() -> void:
	if not can_interact:
		return
	inventory.visible = ! inventory.visible
	can_interact = false
	can_interact_timer.start()

func _on_can_interact_timeout() -> void:
	can_interact = true

func _on_can_interact_start_timeout() -> void:
	can_interact = true
