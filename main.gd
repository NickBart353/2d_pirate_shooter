extends Node

@export var cannonball_scene : PackedScene

func _on_player_shoot_cannonball(position: Variant, target: Variant, player: Variant) -> void:
	var cannonball_instance = cannonball_scene.instantiate()
	cannonball_instance.start_position = position
	cannonball_instance.target = target
	cannonball_instance.player = self
	add_child(cannonball_instance)
