extends Node

var rate : float = 0
onready var Player = $Player
onready var GameHUD = $GameHUD
onready var PlatformManager = $PlatformManager

signal start_game

func _physics_process(delta):
	if (rate < 100):
		rate += 2 * delta

func _ready():
	$CanvasLayer/Blackout.open()
	randomize()
	get_tree().paused = true

func fail():
	get_tree().paused = true
	#set_physics_process(false)
	$CanvasLayer/Blackout.hide()
	var timer = Timer.new()
	timer.wait_time = 2
	timer.autostart = true
	timer.connect("timeout", self, "reset")
	timer.pause_mode = Node.PAUSE_MODE_PROCESS
	add_child(timer)
	
func reset():
	get_tree().reload_current_scene()
	get_tree().paused = false

func start_game():
	GameHUD.get_node("ScorePanel/Score").timer.start()
	$Player/CPUParticles2D.emitting = true
	GameHUD.get_node("ScorePanel").visible = true
	GameHUD.get_node("SkinPanel").visible = false
	GameHUD.get_node("SkinSwitches").visible = false
	PlatformManager.place_section()
	emit_signal("start_game")
