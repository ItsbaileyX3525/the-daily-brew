extends Control

@onready var speech: Label = $MarginContainer/MarginContainer/Speech
@export var typing_speed: float = 40.0 

var line_index: int = 0
var lines: Array[String] = []
var is_speaking: bool = false
var skip: bool = false

signal line_finished()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog"):
		if is_speaking:
			skip = true
		else:
			advance_to_next_line()

func create_dialog(new_lines: Array[String]) -> void:
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
	else:
		#Dialog complete
		visible = false
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

		await get_tree().process_frame
		current_chars += typing_speed * get_process_delta_time()
		speech.visible_characters = int(current_chars)
	
	line_finished.emit()
