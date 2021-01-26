extends Node2D

var pause = true
var rate : float = 35
onready var Player = $Player

var PlatformS = preload("res://scenes/PlatformS.tscn")
var plat_lines = []
var last_plat

func custom_ready():
	#pause = true
	$Player/AnimatedSprite.playing = true
	$Player/CPUParticles2D.emitting = true
	for i in range(-160, 160, 33):
		plat_lines.append(i + randi() % 20 - 10)
	last_plat = add_platform(260, -64)


func _physics_process(delta):
	if (pause): return
	manage_platforms()
	check_failure()
	
func manage_platforms():
	if last_plat.position.x < Player.position.x + 170:
		for y in plat_lines:
			if randf() > 0.5:
				last_plat = add_platform(256, y)


func add_platform(x, y):
	var plat = PlatformS.instance()
	plat.position = Vector2(x, y)
	add_child(plat)
	return plat
	
func check_failure():
	if Player.position.y > 250:
		get_tree().reload_current_scene()
