class_name Player
extends CharacterBody2D

@onready var game = get_parent().get_parent()

@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)
		
@export var speed = 100.0 
@export var acceleration = 100.0 
@export var friction = 100.0
@export var max_line_length = 100
@export var cannonball_scene : PackedScene
@export var cannon_scene : PackedScene
@export var hud_scene : PackedScene

@export var player_input : PlayerInput
@export var input_synchronizer : MultiplayerSynchronizer

var deaths
var score
var charge_max = 200
var charge_start = 50
var charge_current = -1
var charge_speed = 100
var max_ammo = 3
var current_ammo = max_ammo
var direction = Vector2.ZERO
var current_position = Vector2.ZERO
var cannon
var charging : bool = false
var shooting_dir
var max_health = 3
var min_health = 1
var cur_health
#var _player_spawn_points : Array

func _enter_tree() -> void:
	player_input.set_multiplayer_authority(str(name).to_int())

func _ready():
	#if multiplayer.get_unique_id() == player_id:
		#_player_spawn_points = get_tree().get_current_scene().get_node("Map").get_node("Spawnpoints").get_children()
		#self.global_position = _player_spawn_points[NetworkHandler.player_count].global_position
	#cannon = cannon_scene.instantiate()
	#add_child(cannon)
	cur_health = max_health
	score = 0
	deaths = 0
	$Camera2D/ProgressBar.value = cur_health
	EventBus.player_hit.connect(_on_bullet_hit_player.rpc)
	
	input_synchronizer.set_visibility_for(1, true)
	if get_tree().get_multiplayer().get_unique_id() == name.to_int():
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false

func _physics_process(delta: float) -> void:
	if get_tree().get_multiplayer().has_multiplayer_peer() and is_multiplayer_authority():
	#if multiplayer.is_server():
		move_player(delta)
		rotate_cannon()

		if direction.x != 0:
			$Ship_top.flip_h = direction.x < 0
			$Ship_bottom.flip_h = direction.x < 0

		move_and_slide()
		#if multiplayer.is_server():
		#shoot_cannon()
		#charge_cannon(delta)
	
func charge_cannon(delta):
	if charging == false:
		shooting_dir = global_position.direction_to(get_global_mouse_position())
		charge_current = 50
	if current_ammo > 0 and charge_current < charge_max:
		charging = true
		charge_current += charge_speed * delta
	elif current_ammo == 0:
		# play error sound
		return
	#EventBus.charge_player_cannon.emit(charge_current, shooting_dir, global_position)

func shoot_cannon():
	#EventBus.shoot_cannonball.emit(global_position, get_global_mouse_position(), self, shooting_dir, charge_current)
	charging = false
	charge_current = -1
	shooting_dir = 0

func rotate_cannon():
	pass
	#var dir_vec = global_position.direction_to(get_global_mouse_position())
	#cannon.global_position = global_position + (dir_vec * 25) 
	#cannon.look_at(get_global_mouse_position())
	
@rpc("any_peer", "call_local")
func _on_bullet_hit_player(hit_name, hitter):
	if hit_name == self.name: 
		cur_health -= 1
		self.update_healthbar()
		if $Camera2D/ProgressBar.value < min_health:
			game.respawn_player.emit(self, hitter)

func move_player(delta):
	direction = player_input.input_dir
	if direction.length() > 0:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

func update_healthbar():
	$Camera2D/ProgressBar.value = cur_health
