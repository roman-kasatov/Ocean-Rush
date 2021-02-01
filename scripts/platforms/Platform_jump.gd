extends StaticBody2D

var evil = false
var jump_speed = 1300.0

func touch(player):
	player.motion.y = -jump_speed
	player.change_anim_scared()
