extends KinematicBody2D

var gravity = 30
var max_fall_speed = 400
var min_speed = 20
var max_speed = 200
var jump_speed = 700

var motion = Vector2(200, 0)
onready var Game = get_parent()
var jump_left = true

var Floor_part = preload("res://scenes/Floor_particles.tscn")
var Air_part = preload("res://scenes/Air_particles.tscn")

func _ready():
	update_rate()

func _process(delta):
	update_rate()
	if is_on_floor():
		jump_left = true
	motion.y += gravity
	if motion.y > max_fall_speed:
		motion.y = max_fall_speed
	move_and_slide(motion, Vector2.UP)
	
func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if is_on_floor():
				motion.y = -jump_speed
				var particles = Floor_part.instance()
				particles.position = get_global_position() + Vector2(0, 16)
				get_tree().get_root().call_deferred("add_child", particles)
			elif jump_left:
				motion.y = -jump_speed
				jump_left = false
				var particles = Air_part.instance()
				particles.position = get_global_position() + Vector2(0, 16)
				get_tree().get_root().call_deferred("add_child", particles)

func update_rate():
	#motion.x = lerp(min_speed, max_speed, Game.rate / 100)
	pass
	
func change_skin():
	pass
