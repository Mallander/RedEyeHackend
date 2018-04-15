extends KinematicBody2D

signal hit

const GRAVITY = 2500.0

const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 2000
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 500
const STOP_FORCE = 2000
const JUMP_SPEED_MIN = 500
const JUMP_SPEED_MAX = 1050
const JUMP_SPEED_INCREASE = 70
const JUMP_SPEED = 650
const JUMP_MAX_AIRBORNE_TIME = 0.2

const SLIDE_STOP_VELOCITY = 1.0
const SLIDE_STOP_MIN_TRAVEL = 1.0

var dead = false
var velocity = Vector2()
var on_air_time = 100
var jump_final_speed = JUMP_SPEED_MIN;
var jumping = false

var prev_jump_pressed = false
var playingAnim = "";
var lastAnim = "";
var queued = false;
var animToPlay = "";

onready var animationPlayer = get_node("Sprite/AnimationPlayer");
onready var boundary = get_node("/root/Node2D/Bounds");


func _game_over():
	dead = true
	
	playAnim("Death")
	get_node("/root/Node2D/Death").play()
	
	var deathScreenScene = load("res://Scenes/GameOverScreen.tscn")
	var deathScreen = deathScreenScene.instance()
	get_node("/root/Node2D/Foreground_Canvas").call_deferred("add_child", deathScreen)
	
	get_node("/root/Node2D/Background_Music").stop()

func _physics_process(delta):
	var force = Vector2(0, GRAVITY)
	
	var start_walk_left = Input.is_action_just_pressed("left")
	var end_walk_left = Input.is_action_just_released("left")
	var start_walk_right = Input.is_action_just_pressed("right")
	var end_walk_right = Input.is_action_just_released("right")
	var walk_left = Input.is_action_pressed("left")
	var walk_right = Input.is_action_pressed("right")
	var jump_start = Input.is_action_pressed("up")
	var jump_end = Input.is_action_just_released("up")
	
	var stop = true
	
	if not dead:
		if velocity.x == 0 and not jumping:
			animToPlay = "Idle"
		
		if walk_left and not walk_right:
			get_node("Sprite").set_flip_h(true)
			if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
				force.x -= WALK_FORCE
				stop = false
				if is_on_floor() and not jumping:
					animToPlay = "Walk"
		elif walk_right and not walk_left:
			get_node("Sprite").set_flip_h(false)
			if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
				force.x += WALK_FORCE
				if is_on_floor() and not jumping:
					animToPlay = "Walk"
				stop = false
		
		if start_walk_left or start_walk_right and is_on_floor():
			get_node("Running_Audio").play()
		
		if end_walk_left or end_walk_right:
			get_node("Running_Audio").stop()
		
		if stop:
			var vsign = sign(velocity.x)
			var vlen = abs(velocity.x)
			
			vlen -= STOP_FORCE * delta
			if vlen < 0:
				vlen = 0
			
			velocity.x = vlen * vsign
		
	else:
		velocity.x = 0
		force.x = 0
		
	velocity += force * delta
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if not dead:
		if is_on_floor():
			on_air_time = 0
			
		elif not is_on_floor():
			animToPlay = "Jump_Loop"
			
		if jumping and velocity.y > 0:
			jumping = false
		
		if jump_start:
			jump_final_speed += JUMP_SPEED_INCREASE
			
		if (jump_final_speed >= JUMP_SPEED_MAX or jump_end) and on_air_time < JUMP_MAX_AIRBORNE_TIME and not prev_jump_pressed and not jumping:
			
			velocity.y = -clamp(jump_final_speed, JUMP_SPEED_MIN, JUMP_SPEED_MAX)
			jump_final_speed = JUMP_SPEED_MIN
			jumping = true
			
			animToPlay = "Jump_Start"
			get_node("Jump_Audio").play()
		
		on_air_time += delta
		prev_jump_pressed = jump_end
		
		if lastAnim == "Jump_Start" and is_on_floor():
			animToPlay = "Jump_End"
		
		playAnim(animToPlay)


func playAnim(var animName):
	
	if (lastAnim == "Jump_Start" or lastAnim == "Jump_End") and not animName == lastAnim:
		animationPlayer.clear_queue()
		animationPlayer.queue(animName)
		lastAnim = animName;
	
	if not lastAnim == animName:
		animationPlayer.play(animName)
		lastAnim = animName;

func _on_TheWolf_hit():
	_game_over()

func _Area2D_Collision(body):
	print(body)
	emit_signal("hit")

func get_center_pos():
	return get_global_position() + get_node("CollisionSquare").get_global_position()

func Level_End_entered(var nextScene):
	get_tree().change_scene(nextScene)
