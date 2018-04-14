extends Camera2D


func _ready():
	var bounds = get_node("/root/Node2D/Bounds");
	#OS.set_window_size(OS.get_window_size() * 4)
	set_limit(0, bounds.get_left())
	set_limit(1, bounds.get_top())
	set_limit(2, bounds.get_right())
	set_limit(3, bounds.get_bottom())