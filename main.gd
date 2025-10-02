extends Node

@export var cannonball_scene : PackedScene
@export var canon_scene : PackedScene

var canon

func _ready():
	canon = canon_scene.instantiate()
	add_child(canon)
	$Target.visible = false

func _on_player_shoot_cannonball(position: Variant, target: Variant, player: Variant, shooting_dir: Variant, charge: Variant) -> void:
	var cannonball_instance = cannonball_scene.instantiate()
	cannonball_instance.start_position = position
	cannonball_instance.target = (shooting_dir * charge) + position
	cannonball_instance.player = self
	add_child(cannonball_instance)
	$Target.visible = false

func _on_player_rotate_player_canon(mousepos: Variant, player_pos: Variant) -> void:
	var dir_vec = player_pos.direction_to(mousepos)
	canon.global_position = player_pos + (dir_vec * 25) 
	canon.look_at(mousepos)
	#look at mit player_pos machen

func _on_player_charge_player_canon(charge: Variant, charging_dir: Variant, player_pos: Variant) -> void:
	$Target.visible = true
	$Target.position = player_pos + (charging_dir * charge)
