extends Node

var stored_NPC: Dictionary

var NPC_skins: Array = [ #Image path, name
	[preload("uid://filbtpol32uq"), "jessica", "female"],
]

var opening_lines: Array = [
	"Hiya, love.",
	"Good day so far, isn't it?"
]

var filler_lines_start: Array = [
	"I can't wait to try one of your new potions!",
	"Hmmm, what did I need again?",
]

var order_lines: Array = [ #First is line, second is the quest type
	["Could I get a healing potion", "quest_healing_potion"]
]

var filler_lines_end: Array = [
	"And that should be it, thanks",
	"That'll be all",
	"That's it, thanks"
]

var waiting_lines_female: Array = [
	"How's it coming along, darling?",
	"Don't suppose you could be a little faster?",
	"Is it ready yet?",
	"Hurry up, ta ta."
]

var waiting_lines_male: Array = [
	"C'mon, hurry up mate.",
	"What's with the hold up?",
	"Get on with it then.",
	"Just waiting..."
]

func NPC_builder() -> Dictionary:
	var final_speech: Array[String]

	var npc_picker = NPC_skins[randi_range(0, len(NPC_skins) - 1)]
	var npc_skin = npc_picker[0]
	var npc_name = npc_picker[1]

	var opening_line = opening_lines[randi_range(0, len(opening_lines) - 1)]
	var filler_line = filler_lines_start[randi_range(0, len(filler_lines_start) - 1)]
	var order_line = order_lines[randi_range(0, len(order_lines) - 1)]
	var filler_line_end = filler_lines_end[randi_range(0, len(filler_lines_end) - 1)]

	final_speech.append(opening_line)
	final_speech.append(filler_line)
	final_speech.append(order_line[0])
	final_speech.append(filler_line_end)

	stored_NPC.skin = npc_skin 
	stored_NPC.lines = final_speech.duplicate()
	stored_NPC.quest = order_line[1].duplicate()
	stored_NPC.name = npc_name
	if npc_picker[2] == "male":
		stored_NPC.wait_lines = waiting_lines_male.duplicate()
	else:
		stored_NPC.wait_lines = waiting_lines_female.duplicate()

	print(stored_NPC)

	return stored_NPC
