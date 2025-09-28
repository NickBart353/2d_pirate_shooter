extends Node

var cannonballs = []
var ball


func _ready() -> void:
	ball = cannonball.instantiate() 

func _process(delta: float) -> void:
	pass


func _on_player_shoot_cannonball(position: Variant, target: Variant) -> void:
	cannonballs.append("")
