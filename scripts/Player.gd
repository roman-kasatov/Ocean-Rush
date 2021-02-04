extends KinematicBody2D

onready var Eyes = $Body/Eyes
onready var Mouth = $Body/Mouth
onready var Shake = preload("res://scenes/ShakeModule.tscn")

var timer_anim : Timer

var gravity = 30
var max_fall_speed = 400
var min_speed = 200
var max_speed = 400
var jump_speed = 700
var height_to_fail #being calculated at the start at "PlatformManager" script
var was_falling = true
var shifted_time_left = 0

var motion = Vector2(0, 0)
onready var Game = get_parent()
var jump_left = 1

var Floor_part = preload("res://scenes/Floor_particles.tscn")
var Air_part = preload("res://scenes/Air_particles.tscn")


func _ready():
	update_rate()
	timer_anim = Timer.new()
	timer_anim.wait_time = 2
	timer_anim.one_shot = true
	timer_anim.connect("timeout", self, "change_anim_usual")
	add_child(timer_anim)

func _physics_process(delta):
	if position.y > height_to_fail:
		blow_up()
		Game.fail()
	update_rate()
	
	if shifted_time_left > 0:
		shifted_time_left -= delta
		if shifted_time_left <= 0:
			shifted_time_left = 0
			$Body.position.y -= 1
	
	if is_on_floor():
		jump_left = 1
		if was_falling:
			was_falling = false
			shifted_time_left = 0.1
			$Body.position.y += 1
		
	motion.y += gravity
	if motion.y > max_fall_speed:
		motion.y = max_fall_speed
		
	move_and_slide(motion, Vector2.UP)
	
	for i in get_slide_count():
		var coll = get_slide_collision(i).collider
		if coll.is_in_group("touchable"):
			coll.touch(self)


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if is_on_floor():
				motion.y = -jump_speed
				var particles = Floor_part.instance()
				particles.position = get_global_position() + Vector2(0, 16)
				get_tree().get_root().call_deferred("add_child", particles)
			elif jump_left > 0:
				motion.y = -jump_speed
				jump_left -= 1
				var particles = Air_part.instance()
				particles.position = get_global_position() + Vector2(0, 16)
				get_tree().get_root().call_deferred("add_child", particles)


func update_rate():
	motion.x = 0#lerp(min_speed, max_speed, Game.rate / 100)


func _on_DetectorEvil_area_entered(area):
	if area.is_in_group("enemy"):
		blow_up()
		Game.fail()


func blow_up():
	$DeathParticles.emitting = true
	$Legs.visible = false
	$Body.visible = false
	$CPUParticles2D.emitting = false


func change_anim_scared(time):
	timer_anim.wait_time = time
	Eyes.animation = "big"
	Mouth.animation = "fast"
	timer_anim.start()
	#Eyes.add_child(Shake)


func change_anim_usual():
	Eyes.animation = "small"
	Mouth.animation = "slow"
