extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export(String, FILE) var NextScene

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_player_body_entered(body):

	if NextScene == ("res://Scenes/WellDone.tscn") and get_tree().get_current_scene().get_name() == "Level2.tscn":
		get_node("/root/Node2D/TheWolf").won_Game()
	elif body.get_name() == "TheWolf":
		get_node("/root/Node2D/TheWolf").Level_End_entered(NextScene)
	