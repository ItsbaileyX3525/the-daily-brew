extends CharacterBody2D

@export var speed: float = 150.0

@onready var movement_animation_handler: AnimationPlayer = $Movement/MovementAnimationHandler
@onready var idle_animation_handler: AnimationPlayer = $Idle/IdleAnimationHandler
@onready var movement: Sprite2D = $Movement
@onready var idle: Sprite2D = $Idle
@onready var sign_texture: TextureRect = $UI/Text/SignTexture
@onready var sign_text: Label = $UI/Text/SignTexture/SignText
@onready var show_interact_text: Panel = $UI/Text/Panel
@onready var interact_text: Label = $UI/Text/Panel/InteractText
@export var showPlayerFrame: bool = true
@onready var player_frame: Control = $UI/HUD/PlayerFrame
@onready var fade: ColorRect = $UI/Fade
@export var diagonal_walk: bool = true

var sign_interactable: bool = false
var can_teleport: bool = false

var is_idle: bool = false
var time_idle: float = 0.0
@onready var idle_timer: Timer = $Timer/Idle

var location_hold: String
signal tween_complete

func _ready() -> void:
	player_frame.visible = showPlayerFrame
	#Load player hp and that

func parse_string(input: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[(.*?)\\]")
	
	var final_text = input
	var matches = regex.search_all(input)
	
	for m in matches:
		var full_match = m.get_string(0)
		var var_name = m.get_string(1)
		var value = null
		
		if get(var_name) != null:
			value = get(var_name)

		elif DataManager.playerData.has(var_name):
			value = DataManager.playerData[var_name]
			
		if value != null:
			final_text = final_text.replace(full_match, str(value))
		else:
			final_text = final_text.replace(full_match, "Undefined var")
			
	return final_text

func display_sign() -> void:
	if not sign_texture.visible:
		show_interact_text.visible = false
		sign_text.visible = true
		sign_texture.visible = true
	else:
		sign_texture.visible = false
		sign_text.visible = false
		show_interact_text.visible = true
		sign_interactable = true

func fade_transition() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate", Color.hex(0xffffffff), .6)
	tween.tween_callback(tween_complete.emit)

func fade_transition_out() -> void:
	fade.modulate = Color.hex(0x00000)
	var tween = get_tree().create_tween()
	tween.tween_property(fade, "modulate", Color.hex(0xffffffff), .6)
	tween.tween_callback(tween_complete.emit)


func _physics_process(_delta: float) -> void:
	var direction: Vector2

	if Input.is_action_pressed("wl"):
		direction = Vector2.LEFT
	if Input.is_action_pressed("wr"):
		if direction != Vector2.LEFT:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.ZERO
	if Input.is_action_pressed("wf"):
		direction = Vector2.UP
	if Input.is_action_pressed("wb"):
		if direction != Vector2.UP:
			direction = Vector2.DOWN
		else:
			direction = Vector2.ZERO

	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		# Smoothly slow down to a stop
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	
	move_and_slide()
	
	if velocity.length_squared() > 0.1:
		match direction:
			Vector2(0.0, -1.0): #Walking forward
				idle.visible = false
				movement.visible = true
				movement_animation_handler.play("walk_forward")
			Vector2(0.0, 1.0): #Walking backward
				idle.visible = false
				movement.visible = true
				movement_animation_handler.play("walk_back")
			Vector2(-1.0, 0.0): #Walking left
				idle.visible = false
				movement.visible = true
				movement_animation_handler.play("walk_left")
			Vector2(1.0, 0.0): #Walking right
				idle.visible = false
				movement.visible = true
				movement_animation_handler.play("walk_right")

	#Idle animations
	if (not (Input.is_action_pressed("wb") or Input.is_action_pressed("wf") or Input.is_action_pressed("wr") or Input.is_action_pressed("wl")) or not velocity.length_squared() > 0.1) and not idle.visible:
		idle.visible = true
		movement.visible = false
		idle_animation_handler.play("Idle")
		idle_timer.start()
		movement_animation_handler.stop()

	if Input.is_action_just_pressed("interact"):
		match true:
			sign_interactable:
				display_sign()
			can_teleport:
				fade_transition()
				await tween_complete
				Locations.switch_location(location_hold)
		
	

func _on_idle_timeout() -> void:
	#Play idle animation
	idle_animation_handler.play("Idle1")

func _on_idle_animation_handler_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Idle1":
			idle_animation_handler.play("Idle")
			idle_timer.wait_time = randf_range(8,15)
			idle_timer.start()
			
func teleport_trigger(location_info: String) -> void:
	print("Entered teleport trigger")

	interact_text.text = "Press 'e' to enter"
	show_interact_text.visible = true

	if !Locations.check_location(location_info):
		print("Invalid location")
		return
		
	location_hold = location_info
	can_teleport = true

func sign_trigger(sign_text_text: String) -> void:
	print("Entered sign trigger")
	sign_interactable = true
	interact_text.text = "Press 'e' to read sign"
	show_interact_text.visible = true
	var text = parse_string(sign_text_text)
	sign_text.text = text
	return

func left_teleport_trigger() -> void:
	location_hold = ""
	can_teleport = false
	show_interact_text.visible = false
	return

func left_sign_trigger() -> void:
	sign_interactable = false
	sign_texture.visible = false
	show_interact_text.visible = false
	return
