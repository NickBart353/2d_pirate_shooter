extends Area2D

@export var speed = 500

signal hit(player)

var player
var target
var start_position
var current_position
var bodies

func _ready():
	position = start_position

func _physics_process(delta):
	if self.position == target:
		queue_free()

	bodies = get_overlapping_bodies()
	for body in bodies:
		
		if body.is_in_group("players") and body.name != player.name:
			hit.emit(body)
			#body.queue_free()
			queue_free()
		if body.is_in_group("terrain"):
			queue_free()
			continue
	
	position = position.move_toward(target, speed * delta)
