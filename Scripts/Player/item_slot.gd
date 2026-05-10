extends Panel

@onready var icon: TextureRect = $Icon
@onready var tooltip: PanelContainer = $"../../../Tooltip"

func on_mouse_entered():
	if not has_meta("tooltip_text"):
		return
	var tooltip_text = get_meta("tooltip_text")
	if tooltip_text == null or not tooltip_text:
		return
	tooltip.toggle(true, tooltip_text)

func on_mouse_exited():
	tooltip.toggle(false, "")

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if icon.texture == null:
		return
		
	var preview = duplicate()
	var c = Control.new()
	c.add_child(preview)
	preview.position -= Vector2(25, 25)
	preview.self_modulate = Color.TRANSPARENT
	c.modulate = Color(c.modulate, 0.5)
	
	
	set_drag_preview(c)
	icon.hide()
	return {
		"icon": icon,
		"slot": self
	}

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if typeof(data) != TYPE_DICTIONARY:
		return
	if not data.has("icon") or not data.has("slot"):
		return
	var source_icon: TextureRect = data.icon
	var source_slot: Node = data.slot

	var tmp_texture = icon.texture
	icon.texture = source_icon.texture
	source_icon.texture = tmp_texture

	var source_tooltip = source_slot.get_meta("tooltip_text") if source_slot.has_meta("tooltip_text") else null
	var target_tooltip = get_meta("tooltip_text") if has_meta("tooltip_text") else null
	if source_tooltip != null:
		set_meta("tooltip_text", source_tooltip)
	else:
		remove_meta("tooltip_text")
	if target_tooltip != null:
		source_slot.set_meta("tooltip_text", target_tooltip)
	else:
		source_slot.remove_meta("tooltip_text")

	icon.show()
	source_icon.show()
	#Refresh tooltip
	tooltip.toggle(true, source_tooltip)
