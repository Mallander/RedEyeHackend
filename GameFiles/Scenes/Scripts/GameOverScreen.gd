extends Panel


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


func _on_Button_pressed():
	ProjectSettings.set("global_score", 0) # reset score to 0
	get_tree().change_scene("res://Scenes/Main Menu.tscn")
	
	pass # replace with function body

func _on_Panel_draw():
	get_node("Score").text = "Final Score " + str(ProjectSettings.get_setting("global_score"))
