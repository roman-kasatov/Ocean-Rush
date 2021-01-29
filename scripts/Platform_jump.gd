extends StaticBody2D

onready var Game = get_parent()
onready var Player = Game.get_node("Player")

var evil = false
var jump_speed = 1000.0

func do_player_jump():
	Player.motion.y = -jump_speed

func _on_AreaForPlayer_body_entered(body):
	if body is KinematicBody2D:
		do_player_jump()
