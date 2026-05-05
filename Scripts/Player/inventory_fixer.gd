extends Panel

@onready var item_slots: Array = [
	$MarginContainer/GridContainer/ItemSlot, $MarginContainer/GridContainer/ItemSlot2, $MarginContainer/GridContainer/ItemSlot3, $MarginContainer/GridContainer/ItemSlot4, $MarginContainer/GridContainer/ItemSlot5, $MarginContainer/GridContainer/ItemSlot6, $MarginContainer/GridContainer/ItemSlot7, $MarginContainer/GridContainer/ItemSlot8, $MarginContainer/GridContainer/ItemSlot9, $MarginContainer/GridContainer/ItemSlot10, $MarginContainer/GridContainer/ItemSlot11, $MarginContainer/GridContainer/ItemSlot12, $MarginContainer/GridContainer/ItemSlot13, $MarginContainer/GridContainer/ItemSlot14, $MarginContainer/GridContainer/ItemSlot15, $MarginContainer/GridContainer/ItemSlot16
]

func _ready() -> void:
	#Load inventory
	var tmp_data = DataManager.playerInventory.duplicate()
	print(tmp_data)
	for e in tmp_data:
		print(e)
		print("Item slot: ", e[1])
		print("Item name: ", e[0])
		print("Yea: ", DataManager.items[e[0]])
		item_slots[e[1]].get_child(0).texture = DataManager.items[e[0]]

var data_bk
func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_DRAG_BEGIN:
		data_bk = get_viewport().gui_get_drag_data()
	if what == Node.NOTIFICATION_DRAG_END:
		if is_drag_successful():
			return
		if data_bk:
			data_bk.show()
			data_bk = null
