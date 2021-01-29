extends StaticBody2D

onready var Game = get_parent()

var timer

var evil = false
var being_destroyed = false

func _ready():
	timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", self, "destroy")

func destroy():
	var par = $CPUParticles2D
	par.position = position
	remove_child($CPUParticles2D)
	Game.add_child(par)	
	par.start()
	par.emitting = true
	queue_free()

func touch(player):
	being_destroyed = true
	$SpritePlatformAnim.play()
	add_child(timer)
