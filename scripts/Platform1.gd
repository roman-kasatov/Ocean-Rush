extends StaticBody2D

onready var Game = get_parent()
var min_speed = 0.3
var max_speed = 3
var speed = 0.3

func _ready():
	update_rate()

#func _physics_process(delta):
#	update_rate()
#	position.x -= speed
#	if position.x < Game.Player.position.x - 256:
#		queue_free()

func update_rate():
	speed = lerp(min_speed, max_speed, Game.rate / 100)
