extends KinematicBody2D

signal hit

const GRAVITY = 900.0

const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 900
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 300
const STOP_FORCE = 1300
const JUMP_SPEED_MIN = 250
const JUMP_SPEED_MAX = 650
const JUMP_SPEED_INCREASE = 30
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

func _game_over():
	dead = true
	get_node("/root/Node2D/GameOver").text = "GAME OVER"
	get_node("/root/Node2D/Death").play()

func _physics_process(delta):
	var force = Vector2(0, GRAVITY)
	
	var walk_left = Input.is_action_pressed("left")
	var walk_right = Input.is_action_pressed("right")
	var jump_start = Input.is_action_pressed("up")
	var jump_end = Input.is_action_just_released("up")
	
	var stop = true
	if !dead:
		if velocity.x == 0 and not jumping:
			animToPlay = "Idle"
		
		if walk_left:
			get_node("Sprite").set_flip_h(true)
			if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
				force.x -= WALK_FORCE
				stop = false
				if is_on_floor() and not jumping:
					animToPlay = "Walk"
		elif walk_right:
			get_node("Sprite").set_flip_h(false)
			if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
				force.x += WALK_FORCE
				if is_on_floor() and not jumping:
					animToPlay = "Walk"
				stop = false
		
		if stop:
			var vsign = sign(velocity.x)
			var vlen = abs(velocity.x)
			
			vlen -= STOP_FORCE * delta
			if vlen < 0:
				vlen = 0
			
			velocity.x = vlen * vsign
	
		velocity += force * delta
		velocity = move_and_slide(velocity, Vector2(0, -1))
		
		if is_on_floor():
			on_air_time = 0
			
		elif not is_on_floor():
			animToPlay = "Jump_Loop"
			
		if jumping and velocity.y > 0:
			jumping = false
		
		if jump_start:
			jump_final_speed += JUMP_SPEED_INCREASE
			
		if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump_end and not prev_jump_pressed and not jumping:
			
			velocity.y = -clamp(jump_final_speed, JUMP_SPEED_MIN, JUMP_SPEED_MAX)
			animToPlay = "Jump_Start"
			jumping = true
			jump_final_speed = JUMP_SPEED_MIN
		
		on_air_time += delta
		prev_jump_pressed = jump_end
		
		print("Anim to play: " + animToPlay)
		
		if lastAnim == "Jump_Start" and is_on_floor():
			animToPlay = "Jump_End"
		
		print("Last Anim: " + lastAnim)
		
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
	emit_signal("hit")
