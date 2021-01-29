extends StaticBody2D

var evil = false
var jump_speed = 1000.0

func touch(player):
	player.motion.y = -jump_speed
	
