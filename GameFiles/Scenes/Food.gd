extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var food_taken = []

func _ready():
	#get_node("Chainsaw_sound").play()
	pass
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_player_body_entered(body):
	print(body.get_name(), " entered body")
	print(self.get_name(), " self name")
	if body.get_name() == "TheWolf":
		if self.get_name() in food_taken:
			# do nothing, fod already taken
			pass
		else:
			get_node("/root/Node2D/TheWolf").emit_signal("points_10")
			food_taken.append(self.get_name())
			self.hide()
	