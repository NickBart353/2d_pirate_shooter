extends Line2D

var queue : Array = []
@onready var parent = get_parent()
@export var line_size = 7

func _process(_delta: float) -> void:
	var pos = parent.position
	queue.push_front(pos)
	
	if queue.size() > line_size:
		queue.pop_back()
		
	clear_points()
	
	for point in queue:
		add_point(point)
