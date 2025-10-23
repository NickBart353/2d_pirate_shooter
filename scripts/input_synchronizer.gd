extends MultiplayerSynchronizer

var direction
var charging
var shoot

func _ready() -> void:
	
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	shoot = Input.is_action_just_released("shoot")
	charging = Input.is_action_pressed("shoot")
	

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()


func _process(delta: float) -> void:
	pass
