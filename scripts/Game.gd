extends Node

var rate : float = 0
var score = 0
onready var Player = $Player
onready var GameHUD = $GameHUD
onready var PlatformManager = $PlatformManager
onready var Coins = $GameHUD/ScorePanel/Coins

var coins_amount = 0
var opened_flags = ['res://drawable/scarfs/101_flag_mat_orng.png']

signal start_game
var coins_file = "user://coins.save"
var flags_file = "user://flags.save"

func _physics_process(delta):
	if (rate < 100):
		rate += 2 * delta

func _ready():
	randomize()
	load_data()
	Coins.text = str(coins_amount)
	Events.connect('start_game', self, 'start_game')
	$CanvasLayer/Blackout.open()
	$GameHUD/Market.build()
	randomize()
	get_tree().paused = true

func load_data():
	# coins
	var file = File.new()
	if file.file_exists(coins_file):
		file.open(coins_file, File.READ)
		coins_amount = file.get_var()
		file.close()
	# flags
	if file.file_exists(flags_file):
		file.open(flags_file, file.READ)
		opened_flags = file.get_var()
		file.close()

func add_coin(value):
	coins_amount += value
	save_coins_amount()

func save_coins_amount():
	var file = File.new()
	file.open(coins_file, File.WRITE)
	file.store_var(coins_amount)
	file.close()

func save_opened_flags():
	var file = File.new()
	file.open(flags_file, File.WRITE)
	file.store_var(opened_flags)
	file.close()	

func buy_skin(price, path, type='flag'):
	if price > coins_amount:
		return false
	coins_amount -= price
	update_coins()
	if type == 'flag':
		opened_flags.append(path)
		save_opened_flags()
	return true

func update_coins():
	save_coins_amount()
	Coins.text = str(coins_amount)

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
	var score_timer = Timer.new()
	score_timer.wait_time = 1.0
	score_timer.one_shot = false
	score_timer.autostart = true
	score_timer.connect("timeout", self, 'inc_score')
	add_child(score_timer)
	score_timer.start()

	$Player/CPUParticles2D.emitting = true
	GameHUD.get_node("ScorePanel").visible = true
	GameHUD.get_node("Market").visible = false
	GameHUD.get_node("DragChecker").visible = false
#	GameHUD.get_node("SkinSwitches").visible = false
	PlatformManager.place_section()
