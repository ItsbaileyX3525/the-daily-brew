extends Node

const HAND_POINT = preload("uid://c441j51gr7cso")
const HAND_CLOSED = preload("uid://c2p173uxnflqx")
const SCALE_FACTOR = 2.75

func _ready() -> void:
	var hand_point = scale_cursor(HAND_POINT, SCALE_FACTOR)
	var hand_closed = scale_cursor(HAND_CLOSED, SCALE_FACTOR)

	Input.set_custom_mouse_cursor(hand_point, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(hand_closed, Input.CURSOR_FORBIDDEN)
	Input.set_custom_mouse_cursor(hand_closed, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(hand_closed, Input.CURSOR_DRAG)
	
func scale_cursor(texture: Texture2D, factor: int) -> ImageTexture:
	var img = texture.get_image()
	var new_size = Vector2i(img.get_width() * factor, img.get_height() * factor)
	img.resize(new_size.x, new_size.y, Image.INTERPOLATE_NEAREST)
	return ImageTexture.create_from_image(img)
