extends Node

var rate : float = 0
var score = 0
onready var Player = $Player
onready var GameHUD = $GameHUD
onready var PlatformManager = $PlatformManager
onready var Coins = $GameHUD/ScorePanel/Coins

signal start_game

func _physics_process(delta):
	if (rate < 100):
		rate += 2 * delta

func _ready():
	Events.connect('start_game', self, 'start_game')
	$CanvasLayer/Blackout.open()
	randomize()
	get_tree().paused = true


func fail():
	get_tree().paused = true #надо чтоб ничего кроме камеры не останавливалось
	$CanvasLayer/Blackout.hide()
	$Scarf.start_pin = false
	$Scarf.gravity *= 2
	
	var timer = Timer.new()
	timer.wait_time = 2
	timer.autostart = true
	timer.connect("timeout", self, "reset")
	timer.pause_mode = Node.PAUSE_MODE_PROCESS
	add_child(timer)
	
func reset():
	get_tree().reload_current_scene()
	get_tree().paused = false

func inc_score():
	score += 1
	$GameHUD/ScorePanel/Score.text = str(score)

func start_game():
	print('asdfsad')
	var score_timer = Timer.new()
	score_timer.wait_time = 1.0
	score_timer.one_shot = false
	score_timer.autostart = true
	score_timer.connect("timeout", self, 'inc_score')
	add_child(score_timer)
	score_timer.start()

	$Player/CPUParticles2D.emitting = true
#	GameHUD.get_node("ScorePanel").visible = true
#	GameHUD.get_node("SkinPanel").visible = false
#	GameHUD.get_node("SkinSwitches").visible = false
	PlatformManager.place_section()
