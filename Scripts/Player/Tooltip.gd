extends PanelContainer

var opacity_tween: Tween = null
const OFFSET: Vector2 = Vector2.ONE * 35.0
@onready var rich_text_label: RichTextLabel = $MarginContainer/RichTextLabel

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + OFFSET
		size.y = Vector2.ZERO.y

func tween_opacity(to: float):
	if opacity_tween: opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_property(self, "modulate:a", to, .3)
	return opacity_tween

func toggle(on: bool, text: String):
	if on:
		rich_text_label.text = text
		show()
		modulate.a = 0.0
		tween_opacity(1.0)
	else:
		modulate.a = 1.0
		await tween_opacity(0.0).finished
		hide()
