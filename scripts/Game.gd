extends Node

var rate : float = 35
onready var Player = $Player
onready var GameHUD = $Player/Camera2D/GameHUD
onready var PlatformManager = $PlatformManager

#var plat_lines = []
#var last_plat

signal failed
signal start_game

func _ready():
	randomize()
	get_tree().paused = true

func fail():
	get_tree().paused = true
	emit_signal("failed")
	set_physics_process(false)

func start_game():
	GameHUD.get_node("ScorePanel/Score").timer.start()
	$Player/AnimatedSprite.playing = true
	$Player/CPUParticles2D.emitting = true
	$Player/Camera2D/GameHUD/ScorePanel.visible = true
	$Player/Camera2D/GameHUD/SkinPanel.visible = false
	PlatformManager.place_section()
	emit_signal("start_game")
