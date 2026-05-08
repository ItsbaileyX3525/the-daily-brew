extends Control

@onready var continue_button: Button = $TextureRect2/VBoxContainer/Continue

func _ready() -> void:
	continue_button.grab_focus()

func _on_continue_pressed() -> void:
	pass # Replace with function body.

func _on_new_game_pressed() -> void:
	pass # Replace with function body.

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
