class_name PlayerInput
extends Node2D

signal shoot_cannon()
signal charge_cannon(mouse_pos)

var input_dir = Vector2(0,0)
var shoot
var charging

func _ready() -> void:
	if get_tree().get_multiplayer().has_multiplayer_peer() and is_multiplayer_authority():
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		shoot = Input.is_action_just_released("shoot")
		charging = Input.is_action_pressed("shoot")
		if Input.is_action_just_released("shoot"):
			shoot_cannon.emit()
		if  Input.is_action_pressed("shoot"):
			charge_cannon.emit(get_global_mouse_position())

func _physics_process(_delta: float) -> void:
	if get_tree().get_multiplayer().has_multiplayer_peer() and is_multiplayer_authority():
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		if Input.is_action_just_released("shoot"):
			shoot_cannon.emit()
		if  Input.is_action_pressed("shoot"):
			charge_cannon.emit(get_global_mouse_position())
			
