extends Node

var rate : float = 0
onready var Player = $Player
onready var GameHUD = $Player/Camera2D/GameHUD
onready var PlatformManager = $PlatformManager

signal failed
signal start_game

func _physics_process(delta):
	if (rate < 100):
		rate += 3 * delta

func _ready():
	randomize()
	get_tree().paused = true

func fail():
	get_tree().paused = true
	emit_signal("failed")
	set_physics_process(false)

func start_game():
	GameHUD.get_node("ScorePanel/Score").timer.start()
	$Player/CPUParticles2D.emitting = true
	$Player/Camera2D/GameHUD/ScorePanel.visible = true
	$Player/Camera2D/GameHUD/SkinPanel.visible = false
	PlatformManager.place_section()
	emit_signal("start_game")
