extends KinematicBody2D

var gravity = 10
var max_fall_speed = 200
var min_speed = 20
var max_speed = 200
var jump_speed = 200

var motion = Vector2(0, 0)
onready var Game = get_parent()
onready var StartLabel = Game.get_node("TapToStart")
var jump_left = true

var Floor_part = preload("res://scenes/Floor_particles.tscn")
var Air_part = preload("res://scenes/Air_particles.tscn")


func _ready():
	update_rate()


func _process(delta):
	if (Game.pause): return
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
			if (Game.pause):
				$Score.timer.start()
				StartLabel.need_to_erase = true
				Game.pause = false
				Game.custom_ready()
				return
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
