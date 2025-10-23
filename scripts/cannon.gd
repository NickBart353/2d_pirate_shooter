extends Node2D

@export var player_input : PlayerInput
@export var cannonball : PackedScene
@export var target : PackedScene
@export var cannonball_spawn_path : Node2D
@export var target_path : Node2D

@onready var _parent_player = get_parent()

var charging = false
var target_location

func _ready() -> void:
	if player_input:
		player_input.shoot_cannon.connect(_shoot_cannon)
	if player_input:
		player_input.charge_cannon.connect(_charge_cannon)
		
	EventBus.pass_target_location.connect(test)

func _charge_cannon(mouse_pos):
	if not charging:
		_spawn_target.rpc_id(1, mouse_pos) 
		charging = true

@rpc("any_peer", "call_local")
func _spawn_target(mouse_pos):
	var target_scene = target.instantiate() as Node2D
	
	target_scene.initialize_target(mouse_pos)
	target_path.add_child(target_scene, true)
	target_scene.global_position = _parent_player.global_position

func _shoot_cannon():
	EventBus.cannonball_shot.emit()
	_spawn_cannonball.rpc_id(1)
	charging = false

@rpc("any_peer", "call_local")
func _spawn_cannonball():
	var cannonball_scene = cannonball.instantiate() as Node2D
	cannonball_scene.global_position = _parent_player.global_position
	cannonball_scene.initialize_cannonball(target_location)
	cannonball_spawn_path.add_child(cannonball_scene, true)

@rpc("any_peer", "call_local")
func _update_target_location(passed_target_location):
	_get_location.rpc_id(1, passed_target_location)

@rpc("any_peer", "call_local")
func _get_location(passed_target_location):
	self.target_location = passed_target_location
	
func test(passed_target_location):
	_update_target_location.rpc_id(1, passed_target_location)
