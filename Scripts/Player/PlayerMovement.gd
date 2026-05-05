extends CharacterBody2D

@export var speed: float = 150.0

@onready var movement_animation_handler: AnimationPlayer = $Movement/MovementAnimationHandler
@onready var idle_animation_handler: AnimationPlayer = $Idle/IdleAnimationHandler
@onready var movement: Sprite2D = $Movement
@onready var idle: Sprite2D = $Idle

var is_idle: bool = false
var time_idle: float = 0.0
@onready var idle_timer: Timer = $Timer/Idle

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

	move_and_slide()


func _on_idle_timeout() -> void:
	#Play idle animation
	idle_animation_handler.play("Idle1")

func _on_idle_animation_handler_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Idle1":
			idle_animation_handler.play("Idle")
			
func entered_trigger(location_info: String):
	print("Entered trigger")
	
	if !Locations.check_location(location_info):
		print("Invalid location")
		return
		
	
