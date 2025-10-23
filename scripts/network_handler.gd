extends Node

const IP_ADDRESS: String = "localhost"
const PORT: int = 25565 

var peer: ENetMultiplayerPeer
var player_scene : PackedScene = preload("res://scenes/player.tscn")
var _players_spawn_node
#var _player_spawn_points : Array
static var player_count = 0

func start_server() -> void:
	print("Starting host!")
	await get_tree().scene_changed
		
	_players_spawn_node = get_tree().get_current_scene().get_node("Players")
	
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	_add_player_to_game(1)

func start_client() -> void:
	print("New player joining!")
	await get_tree().scene_changed
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer

func disconnect_player(id):
	peer.disconnect_peer(id)
	
func _add_player_to_game(id: int):
	print("Peer %s has joined the game!" %id)
	var player_to_add = player_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	_players_spawn_node.add_child(player_to_add, true)
	player_count += 1
	
func _del_player(id: int):
	print("Peer %s has left the game!" %id)
	if not _players_spawn_node.has_node(str(id)):
		return
	_players_spawn_node.get_node(str(id)).queue_free()
