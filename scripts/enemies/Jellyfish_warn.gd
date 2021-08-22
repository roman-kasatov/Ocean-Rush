extends AnimatedSprite

onready var Player = get_parent()
onready var Game = Player.get_parent()

var timer_for_start = Timer.new()
var timer_for_next = Timer.new()

var spawns_left = 5
var started = 0

var jellyfish_res = preload("res://scenes/enemies/Jellyfish.tscn")

var coord_const

func _ready():
	timer_for_start.wait_time = 0.6
	timer_for_start.autostart = true
	timer_for_start.one_shot = false
	add_child(timer_for_start)
	timer_for_start.connect("timeout", self, "start_jellyfish")


func _physics_process(delta):
	position.y = (coord_const - Player.position.y) / 2

func start_jellyfish():
	if !started:
		timer_for_start.wait_time = 0.15
		started = 1
		return
	
	if !spawns_left:
		queue_free()
		return
	
	var jellyfish = jellyfish_res.instance()
	jellyfish.position = Player.position + position * 2 + Vector2(300, -30)
	Game.add_child(jellyfish)
	Player.change_anim_scared(1.8)
	self.visible = false
	spawns_left -= 1
