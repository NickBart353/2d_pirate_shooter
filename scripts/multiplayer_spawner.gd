extends MultiplayerSpawner

@export var network_player : PackedScene
@onready var map: Node2D = $"../Map/underwater"
var players : Array[Player]

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	spawn_function = spawn_player

func spawn_player(id: int) -> void:
	if !multiplayer.is_server(): return
	
	var player : Node = network_player.instantiate()
	player.name = str(id)
	player.global_position = map.get_child(randi_range(0, players.size())).global_position
	players.append(player)

	get_node(spawn_path).call_deferred("add_child", player)
