extends Node

var rate : float = 0
var score = 0
onready var Player = $Player
onready var GameHUD = $GameHUD
onready var PlatformManager = $PlatformManager
onready var Coins = $GameHUD/ScorePanel/Coins

var coins_amount = 0
var opened_flags = ['res://drawable/scarfs/101_flag_mat_orng.png']
var highscore = 0
var last_score = 0

signal start_game
var coins_file = "user://coins.save"
var flags_file = "user://flags.save"
var scores_file = "user://scores.save"

func _physics_process(delta):
	if (rate < 100):
		rate += 2 * delta

func _ready():
	randomize()
	load_data()
	$ScorePanel/Highscore.text = 'Highscore: ' + str(highscore)
	$ScorePanel/LastScore.text = 'Last score: ' + str(last_score)
	
	# DEBUG
	"""coins_amount = 99999
	update_coins()
	opened_flags = ['res://drawable/scarfs/101_flag_mat_orng.png']
	save_opened_flags()"""
	
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
	# scores
	if file.file_exists(scores_file):
		file.open(scores_file, file.READ)
		var scores = file.get_var()
		highscore = scores['highscore']
		last_score = scores['last_score'] 
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

func save_scores():
	var file = File.new()
	file.open(scores_file, File.WRITE)
	file.store_var({
		'highscore': highscore,
		'last_score': last_score
	})
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
	highscore = max(highscore, score)
	last_score = score
	save_scores()
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

func init_score_timer():
	var score_timer = Timer.new()
	score_timer.wait_time = 1.0
	score_timer.one_shot = false
	score_timer.autostart = true
	score_timer.connect("timeout", self, 'inc_score')
	add_child(score_timer)
	score_timer.start()	

func start_game():
	init_score_timer()
	$Player/CPUParticles2D.emitting = true
	GameHUD.switch_to_game()
	PlatformManager.place_section()
