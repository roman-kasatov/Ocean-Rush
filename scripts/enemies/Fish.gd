extends AnimatedSprite

var type : String
var position_start : Vector2
var position_designated : Vector2

var speed = 0.02
var distantion_passed = 0.0
var bubbles_count = 6
var time_reload = 2.0
var timer_bubbles : Timer

# 0 - moving to designated position
# 1 - watching on player
# 2 - shooting bubbles
# 3 - moving away
var status = 0
onready var Bubble = preload("res://scenes/enemies/BubbleEnemy.tscn")
onready var Canvas = get_parent()
onready var Game = Canvas.get_parent()
onready var Player = Game.get_node("Player")

func _ready():
	position = position_start
	if type == "up":
		animation = "fish_up"
	elif type == "down":
		animation = "fish_down"
	timer_bubbles = Timer.new()
	timer_bubbles.wait_time = time_reload
	timer_bubbles.autostart = true
	timer_bubbles.connect("timeout", self, "shoot_bubble")

func _physics_process(delta):
	if status == 0:
		distantion_passed = min(distantion_passed + speed, 1.0)
		position = lerp(position_start, position_designated, distantion_passed)
		if distantion_passed >= 1.0:
			distantion_passed = 0
			status = 1
			self.play()
	elif status == 3:
		distantion_passed = min(distantion_passed + speed, 1.0)
		position = lerp(position_designated, position_start, distantion_passed)
		if distantion_passed >= 1.0:
			queue_free()

func shoot_bubble():
	if !bubbles_count:
		timer_bubbles.queue_free()
		status = 3
	bubbles_count -= 1
	var bubble = Bubble.instance()
	if type == "up":
		bubble.angle_min += 90
		bubble.angle_max += 90
	elif type == "down":
		bubble.angle_min += 180
		bubble.angle_max += 180

	# position also changes in _ready method of bubble
	bubble.position = position * 0.8
	Game.add_child(bubble)

func _on_Fish_animation_finished():
	status = 2
	add_child(timer_bubbles)
