extends Node2D

func get_left():
	print(get_global_position().x - get_global_position().x)
	return get_global_position().x - get_global_position().x
func get_right():
	return get_global_position().x + get_global_position().x
func get_top():
	return get_global_position().y - get_global_position().y
func get_bottom():
	return get_global_position().y + get_global_position().y