class_name Game
extends Node

@export var cannonball_scene : PackedScene
@onready var my_spawner = $MultiplayerSpawner
@export var player_scene : PackedScene

var players = []
var peer = ENetMultiplayerPeer.new()

signal respawn_player(player, killer)

func _ready():
	if network_manager.is_hosting_game:
		var spawn_manager_scene = load("res://scenes/multiplayer/spawn_manager.tscn")
		var spawn_manager = spawn_manager_scene.instantiate()
		spawn_manager.player_scene = player_scene
		add_child(spawn_manager)
		respawn_player.connect(_respawn_player)
	#add_player()
	#EventBus.connect("shoot_cannonball", _on_player_shoot_cannonball)
	
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
	pass
	#var player = player_scene.instantiate()
	#add_child(player)


func _on_main_menu_pressed() -> void:
	network_manager.terminate_connection_load_main_menu()

func _respawn_player(player, killer):
	_reset_player_stats.rpc_id(1, player, killer)

@rpc("call_local")
func _reset_player_stats(player, killer):
	player.global_transform = Transform2D(0, Vector2(randi_range(30, 50), randi_range(30, 50)))
	player.cur_health = player.max_health
	player.deaths += 1
	killer.score += 1
	print(killer.name, "\nKills: ", killer.score, "\nDeaths: ", killer.deaths)
	player.update_healthbar()
