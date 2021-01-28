extends StaticBody2D

onready var Game = get_parent()

var timer

var evil = false

func _ready():
	timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", self, "destroy")


func destroy():
	queue_free()



func _on_AreaForPlayer_body_entered(body):
	if (body is KinematicBody2D):
		add_child(timer)
