extends Node2D

var target_location : Vector2
var start_location  : Vector2
var speed = 100
var max_distance : int = 200
var direction

func initialize_target(mouse_position: Vector2):
	self.target_location = global_position.direction_to(mouse_position) * max_distance
	#self.start_location = global_position
	self.direction = start_location.direction_to(target_location)

func _ready() -> void:
	EventBus.cannonball_shot.connect(_remove_func_rpc)
	start_location = global_position

func _process(delta: float) -> void:
	if target_location and not (global_position.distance_to(start_location)) > max_distance:
		global_position = global_position + direction * speed * delta

@rpc("any_peer", "call_local")
func _remove_target_and_pass_location():
	EventBus.pass_target_location.emit(global_position)
	queue_free()
	
func _remove_func_rpc():
	_remove_target_and_pass_location.rpc_id(1)
