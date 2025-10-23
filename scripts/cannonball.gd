extends Area2D

@export var speed = 300

signal hit(player)

@onready var player = get_parent().get_parent()
var target_location
var start_position
var current_position
var bodies

func initialize_cannonball(location):
	self.target_location = location

func _ready():
	pass

func _physics_process(delta):
	if is_multiplayer_authority() and get_multiplayer_authority() == 1:
		move_cannonball.rpc_id(1, delta)

@rpc("authority","call_local")
func move_cannonball(delta):
	global_position = global_position.move_toward(target_location, speed * delta)
	
	if self.global_position == target_location:
		queue_free()
	
	bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("players") and body.name != player.name:
			hit.emit(body)
			EventBus.player_hit.emit(body.name, player)
			#EventBus.increase_player_score.emit(player.name) INCREASING PLAYER SCORE
			queue_free()
			continue
		if body.is_in_group("terrain"):
			queue_free()
			continue
