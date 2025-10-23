class_name SpawnManager
extends Node

var player_scene : PackedScene
@onready var spawn_path : Node2D = get_tree().current_scene.get_node("%SpawnPath")

func _ready() -> void:
	get_tree().get_multiplayer().peer_connected.connect(_peer_connected)
	get_tree().get_multiplayer().peer_disconnected.connect(_peer_disconnected)
	
	_add_player_to_game(1)
	
func _peer_connected(network_id):
	print("Peer connected: %s" % network_id)
	_add_player_to_game(network_id)

func _peer_disconnected(network_id):
	print("Peer disconnected: %s" % network_id)
	var player_to_remove = spawn_path.find_child(str(network_id), false, false)
	if player_to_remove:
		player_to_remove.queue_free()

func _add_player_to_game(network_id : int):
	var player_to_add = player_scene.instantiate()
	player_to_add.name =  str(network_id)
	
	player_to_add.set_multiplayer_authority(1)
	
	if network_id == 1:
		player_to_add.global_transform = Transform2D(0, Vector2(randi_range(0, 20), randi_range(0, 20)))
	else:
		player_to_add.global_transform = Transform2D(0, Vector2(randi_range(30, 50), randi_range(30, 50)))
	
	spawn_path.add_child(player_to_add)
