extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_player_body_entered(body):
	print(body.get_name(), " entered body")
	if body.get_name() == "TheWolf":
		get_node("/root/Node2D/TheWolf").emit_signal("hit")
	
