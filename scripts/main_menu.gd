extends Control

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_start_server_pressed() -> void:
	network_manager.create_server()
	network_manager.load_game_scene()

func _on_start_client_pressed() -> void:
	network_manager.load_game_scene()
	network_manager.create_client()
