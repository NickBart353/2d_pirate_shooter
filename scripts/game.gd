extends Node

@export var cannonball_scene : PackedScene
@onready var my_spawner = $MultiplayerSpawner

var players = []

func _ready():
	# Connect the MultiplayerSpawner's 'spawned' signal
	my_spawner.spawned.connect(_on_multiplayer_spawner_spawned)
	
func _on_multiplayer_spawner_spawned(node: Node):
	if node is CharacterBody2D: 
		node.shoot_cannonball.connect(_on_player_shoot_cannonball)
		players.append(node)

func _on_player_shoot_cannonball(position: Variant, target: Variant, player: Variant, shooting_dir: Variant, charge: Variant):
	var cannonball_instance = cannonball_scene.instantiate()
	for player_instance in players:
		#if player.name == player_instance.name:
		cannonball_instance.connect("hit", Callable(player_instance, "_on_bullet_hit"))
	cannonball_instance.start_position = position
	cannonball_instance.target = (shooting_dir * charge) + position
	cannonball_instance.player = player
	add_child(cannonball_instance)
