extends CharacterBody2D

@export var speed = 100.0 
@export var acceleration = 100.0 
@export var friction = 100.0
@export var max_line_length = 100
@export var cannonball_scene : PackedScene
signal shoot_cannonball(position, target, player)

var ball : PackedScene
var direction = Vector2.ZERO
var current_position = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	if direction.x != 0:
		$Ship_top.flip_h = direction.x < 0
		$Ship_bottom.flip_h = direction.x < 0

	if direction.length() > 0:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	move_and_slide()
	
	if Input.is_action_just_released("shoot"):
		shoot_cannon()

func charge_cannon():
	pass

func shoot_cannon():
	shoot_cannonball.emit(global_position, get_global_mouse_position(), self)	
