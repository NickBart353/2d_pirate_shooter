extends Node

const SERVER_PORT : int = 8080
const GAME_SCENE : String = "res://scenes/game.tscn"
const MAIN_MENU_SCENE : String = "res://scenes/main_menu.tscn"
var is_hosting_game = false

func create_server():
	is_hosting_game = true
	var server_peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT)
	get_tree().get_multiplayer().multiplayer_peer = server_peer
	print("Server created!")

func create_client(host_ip : String = "localhost", host_port : int = SERVER_PORT):
	_setup_client_connection_signals()
	is_hosting_game = false
	
	var client_peer : ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	client_peer.create_client(host_ip, host_port)
	get_tree().get_multiplayer().multiplayer_peer = client_peer
	print("Client is created!")
	
func _setup_client_connection_signals():
	if not get_tree().get_multiplayer().server_disconnected.is_connected(_server_disconnected):
		get_tree().get_multiplayer().server_disconnected.connect(_server_disconnected)
	
func _server_disconnected():
	print("Server disconnected")
	terminate_connection_load_main_menu()

func load_game_scene():
	print("Loading game scene...")
	get_tree().call_deferred("change_scene_to_packed", preload(GAME_SCENE))
	
func terminate_connection_load_main_menu():
	print("Terminate connection, load main menu...")
	_load_main_menu()
	_terminate_connection()
	_disconnect_client_connection_signal()
	
func _load_main_menu():
	get_tree().call_deferred("change_scene_to_packed", preload(MAIN_MENU_SCENE))

func _terminate_connection():
	print("Terminate connection")
	get_tree().get_multiplayer().multiplayer_peer = null

func _disconnect_client_connection_signal():
	if get_tree().get_multiplayer().server_disconnected.has_connections():
		get_tree().get_multiplayer().server_disconnected.disconnect(_server_disconnected)
