extends Line2D

@export var character: Node2D

@export var line_size = 20 
@export var line_width = 5.0
@export var line_color = Color(1, 1, 1, 0.5)
@export var trail_origin_marker: Marker2D

var queue: Array = []

func _ready() -> void:
	width = line_width
	default_color = line_color
	gradient = Gradient.new()
	gradient.colors = [Color(1,1,1,1), Color(1,1,1,0)]


func _process(_delta: float) -> void:
	if not is_instance_valid(character):
		return

	var global_pos = character.global_position
	queue.push_front(global_pos)
	
	if queue.size() > line_size:
		queue.pop_back()
		
	clear_points()
	for point in queue:
		add_point(point)
