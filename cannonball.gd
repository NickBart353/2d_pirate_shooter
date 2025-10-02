extends Area2D

@export var speed = 500

var player
var target
var start_position
var current_position

func _ready():
	position = start_position

func _physics_process(delta):
	if self.position == target:
		queue_free()
	
	position = position.move_toward(target, speed * delta)

func _on_Bullet_body_entered(body):
	if body.is_in_group("players") and body != player:
		body.queue_free()
	queue_free()
