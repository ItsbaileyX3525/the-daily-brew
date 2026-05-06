extends CharacterBody2D

@export var speed: float = 150.0

@onready var movement_animation_handler: AnimationPlayer = $Movement/MovementAnimationHandler
@onready var idle_animation_handler: AnimationPlayer = $Idle/IdleAnimationHandler
@onready var movement: Sprite2D = $Movement
@onready var idle: Sprite2D = $Idle
@onready var sign_texture: TextureRect = $UI/Text/SignTexture
@onready var sign_text: Label = $UI/Text/SignTexture/SignText
@onready var show_sign_text: Panel = $UI/Text/Panel

var sign_interactable: bool = false

var is_idle: bool = false
var time_idle: float = 0.0
@onready var idle_timer: Timer = $Timer/Idle

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
	print("toggling sign")
	if not sign_texture.visible:
		show_sign_text.visible = false
		sign_text.visible = true
		sign_texture.visible = true
	else:
		sign_texture.visible = false
		sign_text.visible = false
		show_sign_text.visible = true
		sign_interactable = true

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("wl", "wr", "wf", "wb")
	
	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		# Smoothly slow down to a stop
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	#Idle animations
	if not (Input.is_action_pressed("wb") or Input.is_action_pressed("wf") or Input.is_action_pressed("wr") or Input.is_action_pressed("wl")):
		idle.visible = true
		movement.visible = false
		idle_animation_handler.play("Idle")
		idle_timer.start()
		
	#Movement animations
	if Input.is_action_just_pressed("wl"):
		idle.visible = false
		movement.visible = true
		movement_animation_handler.play("walk_left")
	if Input.is_action_just_pressed("wr"):
		idle.visible = false
		movement.visible = true
		movement_animation_handler.play("walk_right")
	if Input.is_action_just_pressed("wb"):
		idle.visible = false
		movement.visible = true
		movement_animation_handler.play("walk_back")
	if Input.is_action_just_pressed("wf"):
		idle.visible = false
		movement.visible = true
		movement_animation_handler.play("walk_forward")

	if sign_interactable and Input.is_action_just_pressed("interact"):
		display_sign()

	move_and_slide()

func _on_idle_timeout() -> void:
	#Play idle animation
	idle_animation_handler.play("Idle1")

func _on_idle_animation_handler_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Idle1":
			idle_animation_handler.play("Idle")
			
func house_trigger(location_info: String) -> void:
	print("Entered house trigger")
	
	if !Locations.check_location(location_info):
		print("Invalid location")
		return
		
func sign_trigger(sign_text_text: String) -> void:
	print("Entered sign trigger")
	sign_interactable = true
	show_sign_text.visible = true
	var text = parse_string(sign_text_text)
	sign_text.text = text
	return

func left_house_trigger() -> void:
	return

func left_sign_trigger() -> void:
	sign_interactable = false
	sign_texture.visible = false
	show_sign_text.visible = false
	return
