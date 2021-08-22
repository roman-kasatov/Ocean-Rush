extends AnimatedSprite

onready var Player = get_parent()
onready var Game = Player.get_parent()

var timer_for_submarine = Timer.new()

var submarine_res = preload("res://scenes/enemies/Submarine.tscn")

var coord_const

func _ready():
	timer_for_submarine.wait_time = 1.8
	timer_for_submarine.autostart = true
	add_child(timer_for_submarine)
	timer_for_submarine.connect("timeout", self, "start_moving")

func _physics_process(delta):
	position.y = (coord_const - Player.position.y) / 2

func start_moving():
	var submarine = submarine_res.instance()
	submarine.position = Player.position + position * 2 + Vector2(540, -30)
	Game.add_child(submarine)
	Player.change_anim_scared(2.8)
	queue_free()
