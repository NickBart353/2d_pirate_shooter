extends CharacterBody2D

@export var speed = 100.0 
@export var acceleration = 100.0 
@export var friction = 100.0
@export var max_line_length = 100
@export var cannonball_scene : PackedScene
@export var canon_scene : PackedScene
@export var hud_scene : PackedScene
signal shoot_cannonball(position, target, player, shooting_dir, charge)
signal rotate_player_canon(mousepos, player_pos)
signal charge_player_canon(charge, charging_dir, player_pos)

var charge_max = 200
var charge_start = 50
var charge_current = -1
var charge_speed = 100
var max_ammo = 3
var current_ammo = max_ammo
var direction = Vector2.ZERO
var current_position = Vector2.ZERO
var canon
var charging : bool = false
var shooting_dir

func _ready():
	var hud = hud_scene.instantiate()
	add_child(hud)

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()

	if direction.x != 0:
		$Ship_top.flip_h = direction.x < 0
		$Ship_bottom.flip_h = direction.x < 0

	if direction.length() > 0:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	move_and_slide()
	
	if Input.is_action_just_released("shoot"):
		shoot_cannon()
	
	if Input.is_action_pressed("shoot"):
		charge_canon(delta)
		
	rotate_canon()

func charge_canon(delta):
	if charging == false:
		shooting_dir = global_position.direction_to(get_global_mouse_position())
		charge_current = 50
	if current_ammo > 0 and charge_current < charge_max:
		charging = true
		charge_current += charge_speed * delta
	elif current_ammo == 0:
		# play error sound
		return
	charge_player_canon.emit(charge_current, shooting_dir, global_position)

func shoot_cannon():
	shoot_cannonball.emit(global_position, get_global_mouse_position(), self, shooting_dir, charge_current)
	charging = false
	charge_current = -1
	shooting_dir = 0

func rotate_canon():
	rotate_player_canon.emit(get_global_mouse_position(), global_position)
