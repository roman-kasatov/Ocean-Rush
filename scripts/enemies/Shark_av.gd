extends AnimatedSprite

onready var Player = get_parent()
onready var Game = Player.get_parent()

var timer_for_shark = Timer.new()

var Shark_res = preload("res://scenes/enemies/Shark_standart.tscn")

var coord_const

func _ready():
	timer_for_shark.wait_time = 1.2
	timer_for_shark.autostart = true
	add_child(timer_for_shark)
	timer_for_shark.connect("timeout", self, "start_moving")

func _physics_process(delta):
	position.y = (coord_const - Player.position.y) / 2

func start_moving():
	var shark = Shark_res.instance()
	shark.position = Player.position + position * 2 + Vector2(300, -30)
	Game.add_child(shark)
	Player.change_anim_scared(1.8)
	queue_free()
