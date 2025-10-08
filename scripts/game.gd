class_name Game
extends Node

@export var cannonball_scene : PackedScene
@onready var my_spawner = $MultiplayerSpawner
@export var player_scene : PackedScene

var players = []
var peer = ENetMultiplayerPeer.new()

func _ready():
	add_player()
	
func _on_player_shoot_cannonball(position: Variant, target: Variant, player: Variant, shooting_dir: Variant, charge: Variant):
	var cannonball_instance = cannonball_scene.instantiate()
	for player_instance in players:
		#if player.name == player_instance.name:
		cannonball_instance.connect("hit", Callable(player_instance, "_on_bullet_hit"))
	cannonball_instance.start_position = position
	cannonball_instance.target = (shooting_dir * charge) + position
	cannonball_instance.player = player
	add_child(cannonball_instance)
	
func add_player():
	var player = player_scene.instantiate()
	add_child(player)
