extends Control

var NPC_position: Vector2 = Vector2(310.0, -112)
@onready var NPC_node: Control = $NPCs

var NPCs: Array[PackedScene] = [
	preload("uid://c5judjvsg4vqj"),
]

@onready var dialogue: Control = %Dialogue
@onready var npc_encounter: Timer = $NPCEncounter

var curr_npc: TextureRect

func _ready() -> void:
	npc_encounter.wait_time = randf_range(2,10)

func _process(_delta: float) -> void:
	pass

func _on_npc_encounter_timeout() -> void:
	print("loading npc")
	var random_npc = randi_range(0, NPCs.size() - 1)
	
	curr_npc = NPCs[random_npc].instantiate()
	print("ready")
	NPC_node.add_child(curr_npc)
	curr_npc.position = NPC_position
	dialogue.create_dialog(curr_npc.lines)

func _on_inventory_hover_mouse_entered() -> void:
	print("Open inventory")
 
func _on_cauldron_hover_mouse_entered() -> void:
	print("Open brew")
