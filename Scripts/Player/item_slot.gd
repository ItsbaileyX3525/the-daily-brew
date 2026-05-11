extends Button

@onready var item_icon: TextureRect = $Icon
@export var tooltip_path: NodePath
@onready var tooltip: PanelContainer = _resolve_tooltip()
@export var preview_offset: Vector2 = Vector2(25,25)
var is_hovering: bool = false

signal wants_to_equip(item_name: String)

func _input(e):
	if not is_hovering:
		return
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT and e.double_click:
		print("equip: ", get_meta("item"))
		wants_to_equip.emit(get_meta("item"))

func _resolve_tooltip() -> PanelContainer:
	if tooltip_path != NodePath():
		var tooltip_by_path := get_node_or_null(tooltip_path) as PanelContainer
		if tooltip_by_path != null:
			return tooltip_by_path

	var inventory_parent := find_parent("Inventory")
	if inventory_parent != null:
		var tooltip_in_inventory := inventory_parent.get_node_or_null("Tooltip") as PanelContainer
		if tooltip_in_inventory != null:
			return tooltip_in_inventory

	var default_tooltip := get_node_or_null("../../../Tooltip") as PanelContainer
	if default_tooltip != null:
		return default_tooltip

	return null

func on_mouse_entered():
	is_hovering = true
	if tooltip == null:
		return
	if not has_meta("tooltip_text"):
		return
	var tooltip_text = get_meta("tooltip_text")
	if tooltip_text == null or not tooltip_text:
		return
	tooltip.toggle(true, tooltip_text)

func on_mouse_exited():
	if tooltip == null:
		return
	tooltip.toggle(false, "")
	is_hovering = false

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if item_icon.texture == null:
		return
		
	var preview = duplicate()
	var c = Control.new()
	c.add_child(preview)
	preview.position -= preview_offset
	preview.self_modulate = Color.TRANSPARENT
	c.modulate = Color(c.modulate, 0.5)

	set_drag_preview(c)
	item_icon.hide()
	return {
		"item_icon": item_icon,
		"slot": self
	}

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true
	
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if typeof(data) != TYPE_DICTIONARY:
		return
	if not data.has("item_icon") or not data.has("slot"):
		return
	var source_icon: TextureRect = data.item_icon
	var source_slot: Node = data.slot

	var tmp_texture = item_icon.texture
	item_icon.texture = source_icon.texture
	source_icon.texture = tmp_texture

	var source_item = source_slot.get_meta("item") if source_slot.has_meta("item") else null
	var target_item = get_meta("item") if has_meta("item") else null
	if source_item != null:
		set_meta("item", source_item)
	else:
		remove_meta("item")
	if target_item != null:
		source_slot.set_meta("item", target_item)
	else:
		source_slot.remove_meta("item")

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

	item_icon.show()
	source_icon.show()
	#Refresh tooltip
	if tooltip != null:
		tooltip.toggle(true, source_tooltip)
