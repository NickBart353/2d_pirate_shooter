extends CharacterBody2D

@export var speed = 100.0 
@export var acceleration = 100.0 
@export var friction = 100.0

var direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	if direction.x != 0:
		$PlayerSprite.flip_h = direction.x < 0

	if direction.length() > 0:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
