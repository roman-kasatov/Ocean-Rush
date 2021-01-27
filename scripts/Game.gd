extends Node

var rate : float = 35
onready var Player = $Player
onready var GameHUD = $Player/Camera2D/GameHUD

#var PlatformS = preload("res://scenes/PlatformS.tscn")
#var plat_lines = []
#var last_plat

signal failed
signal start_game

func _ready():
	get_tree().paused = true

func _physics_process(delta):
	manage_platforms()
	check_failure()
	
func manage_platforms():
#	if last_plat.position.x < Player.position.x + 700:
#		for y in plat_lines:
#			if randf() > 0.5:
#				last_plat = add_platform(700, y)
	pass

#func add_platform(x, y):
#	var plat = PlatformS.instance()
#	plat.position = Vector2(x, y)
#	add_child(plat)
#	return plat
	
func check_failure():
	if Player.position.y > 800:
		#get_tree().change_scene("res://scenes/MainMenu.tscn")
		get_tree().paused = true
		emit_signal("failed")
		set_physics_process(false)
		
func start_game():
	GameHUD.get_node("ScorePanel/Score").timer.start()
	$Player/AnimatedSprite.playing = true
	$Player/CPUParticles2D.emitting = true
	$Player/Camera2D/GameHUD/ScorePanel.visible = true
	$Player/Camera2D/GameHUD/SkinPanel.visible = false
	emit_signal("start_game")
#	for i in range(-160, 160, 33):
#		plat_lines.append(i + randi() % 20 - 10)
#	last_plat = add_platform(260, -64)
#	print("done")
