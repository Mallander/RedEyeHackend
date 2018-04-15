extends MarginContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	ProjectSettings.set("global_score", 0) # reset score to 0
	get_node("StartButton")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Start_pressed():
	ProjectSettings.set("global_score", 0) # reset score to 0
	get_tree().change_scene("res://Scenes/MainScene.tscn")
	pass # replace with function body
