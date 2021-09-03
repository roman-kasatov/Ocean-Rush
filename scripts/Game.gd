extends Node

var rate : float = 0
var score = 0
var score_max = 160
onready var Player = $Player
onready var GameHUD = $GameHUD
onready var PlatformManager = $PlatformManager
onready var Coins = $GameHUD/ScorePanel/Coins

var coins_amount = 0
var opened_flags
var highscore = 0
var last_score = 0
var cur_flag
var help_shown = false

signal start_game
var coins_file = "user://coins.save"
var flags_file = "user://flags.save"
var cur_flag_file = "user://cur_flag.sav"
var scores_file = "user://scores.save"
var help_file = "user://help.save"
var is_alive = true

var flags_path = 'res://drawable/scarfs/'

func _physics_process(delta):
	if (rate < score_max):
		rate += 2 * delta

func clear_saves():
	var dir = Directory.new()
	for file in [coins_file, flags_file, cur_flag_file, scores_file, help_file]:
		dir.remove(file)

func _ready():
	# DEBUG
	#clear_saves()

	randomize()
	cur_flag = get_first_flag()
	opened_flags = [cur_flag]
	load_data()
	$ScorePanel/Highscore.text = 'Highscore: ' + str(highscore)
	$ScorePanel/LastScore.text = 'Last score: ' + str(last_score)
	if not help_shown:
		GameHUD.show_help_arrow()
	
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

func get_first_flag():
	var names = []
	var dir = Directory.new()
	if dir.open(flags_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if OS.get_name() == 'Android':
				file_name = file_name.replace('.import', '')
			if not dir.current_is_dir() and file_name.ends_with('.png') or file_name.ends_with('.jpg'):
				return flags_path + file_name
			file_name = dir.get_next()
	return null

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
	# current flag
	if file.file_exists(cur_flag_file):
		file.open(cur_flag_file, file.READ)
		cur_flag = file.get_var()
		$Scarf.set_skin('flag', cur_flag)
		file.close()
	# if help message shown
	if file.file_exists(help_file):
		file.open(help_file, file.READ)
		help_shown = file.get_var()
		file.close()

func add_coin(value):
	coins_amount += value
	save_coins_amount()

func save_coins_amount():
	var file = File.new()
	file.open(coins_file, File.WRITE)
	file.store_var(coins_amount)
	file.close()

func set_help_shown():
	help_shown = true
	var file = File.new()
	file.open(help_file, File.WRITE)
	file.store_var(help_shown)
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

func save_cur_flag():
	var file = File.new()
	file.open(cur_flag_file, File.WRITE)
	file.store_var(cur_flag)
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
	is_alive = false
	highscore = max(highscore, score)
	last_score = score
	save_scores()
	$Player.set_physics_process(false)
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
	if is_alive:
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
