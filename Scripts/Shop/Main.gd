extends Control

var NPC_position: Vector2 = Vector2(310.0, -112)
@onready var NPC_node: Control = $NPCs
@onready var fade: ColorRect = $Fade
@onready var inventory: Control = $Inventory
@onready var can_interact_timer: Timer = $CanInteract

var defined_NPCS: Dictionary = {
	"introElf" : preload("uid://c5judjvsg4vqj")
}
const BREW = preload("uid://dqmcg4r3sqf6y")

@onready var dialogue: Control = %Dialogue
@onready var npc_encounter: Timer = $NPCEncounter

var curr_npc: Button
var interacted_with_NPC: bool = false
var can_interact: bool = false

func cleanup_old_customer() -> void:
	curr_npc.queue_free()
	curr_npc = null
	interacted_with_NPC = false

func customer_clicked(NPC_data: Dictionary) -> void:
	if not interacted_with_NPC:
		if dialogue.visible:
			return
		print("Interacted")
		print(NPC_data.lines)
		dialogue.create_dialog(NPC_data.lines, curr_npc)
		interacted_with_NPC = true
	else:
		var tmp_line: Array[String] = [NPC_data.wait_lines[randi_range(0, len(NPC_data.wait_lines) - 1)]]
		dialogue.create_dialog(tmp_line, curr_npc)
		tmp_line = []

func finished_intro_talk() -> void:
	dialogue.disconnect("dialog_complete", finished_intro_talk)
	print("Finished intro talk ")
	cleanup_old_customer()
	var NPC = NpcHandler.NPC_customer_builder(0,0,0,0,0) #Complete basic
	curr_npc = Button.new()
	curr_npc.flat = true
	curr_npc.focus_mode = Control.FOCUS_NONE
	curr_npc.icon = NPC.skin
	curr_npc.position = NPC_position
	NPC_node.add_child(curr_npc)
	curr_npc.position = NPC_position
	curr_npc.connect("pressed", customer_clicked.bind(NPC))
	pass

func _ready() -> void:
	#npc_encounter.wait_time = randf_range(2,10)
	await get_tree().create_timer(.2).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate", Color.hex(0xffffff00), .6)
	await tween.finished
	tween.kill() #Just ensure it's been removed from the tree
	tween = null

	var firstPlay = DataManager.playerData["firstPlay"]
	if firstPlay == "true":
		await get_tree().create_timer(1.2).timeout
		curr_npc = defined_NPCS["introElf"].instantiate()
		curr_npc.focus_mode = Control.FOCUS_NONE
		dialogue.connect("dialog_complete", finished_intro_talk)
		NPC_node.add_child(curr_npc)
		curr_npc.position = NPC_position
		dialogue.create_dialog(curr_npc.lines, curr_npc)
		return

func _process(_delta: float) -> void:
	pass

func _on_inventory_hover_mouse_entered() -> void:
	if not can_interact:
		return
	inventory.visible = ! inventory.visible
	can_interact =  false
	can_interact_timer.start()
 
func _on_cauldron_hover_mouse_entered() -> void:
	if not can_interact:
		return
	dialogue.clear()
	get_tree().change_scene_to_packed(BREW)

func _on_can_interact_timeout() -> void:
	can_interact = true

func _on_can_interact_start_timeout() -> void:
	can_interact = true
