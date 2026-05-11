extends Control

@onready var speech: Label = $MarginContainer/MarginContainer/Speech
@export var typing_speed: float = 40.0 

var line_index: int = 0
var lines: Array[String] = []
var is_speaking: bool = false
var skip: bool = false
var character: Button 

signal line_finished()
signal dialog_complete()

func bounce_npc() -> void:
	var curr_pos = character.position
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(character, "position", Vector2(curr_pos.x, curr_pos.y-10.0), .15)
	tween.set_ease(tween.EASE_IN_OUT)
	await tween.finished
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween2.tween_property(character, "position", Vector2(curr_pos.x,curr_pos.y), .1)
	tween2.set_ease(tween.EASE_IN_OUT)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog"):
		get_tree().root.set_input_as_handled()
		if is_speaking:
			skip = true
		else:        
			advance_to_next_line()

func clear() -> void:
	line_index = 0
	lines = []
	is_speaking = false
	skip = false
	visible = false
	character = null

func create_dialog(new_lines: Array[String], character_btn: Button) -> void:
	if visible and lines.size() > 0:
		return
	character = character_btn
	bounce_npc() #Inital bounce on load
	if not visible:
		visible = true 
	lines = new_lines
	line_index = 0
	if line_finished.is_connected(_on_line_finished):
		line_finished.disconnect(_on_line_finished)
	line_finished.connect(_on_line_finished)
	
	start_typing()

func advance_to_next_line() -> void:
	line_index += 1
	if line_index < lines.size():
		start_typing()
		bounce_npc()
	else:
		#Dialog complete
		if character:
			dialog_complete.emit()
		line_index = 0
		lines = []
		is_speaking = false
		skip = false
		visible = false
		character = null
		pass

func start_typing() -> void:
	display_text(lines[line_index])

func _on_line_finished() -> void:
	is_speaking = false

func display_text(text: String) -> void:
	speech.text = text
	speech.visible_characters = 0
	is_speaking = true
	skip = false
	
	var total_chars = text.length()
	var current_chars: float = 0.0

	while speech.visible_characters < total_chars:
		if skip:
			speech.visible_characters = total_chars
			break

		if get_tree() == null: #Switched to brew or something
			return
		await get_tree().process_frame
		current_chars += typing_speed * get_process_delta_time()
		speech.visible_characters = int(current_chars)
	
	line_finished.emit()
