extends Node2D

var left_stop = true;
var right_stop = true;
var top_stop = true;

func get_left():
	return get_global_position().x - get_global_position().x
func get_right():
	return get_global_position().x + get_global_position().x
func get_top():
	return get_global_position().y - get_global_position().y
func get_bottom():
	return get_global_position().y + get_global_position().y