extends AnimatedSprite

var speed_x = 1.0
var max_speed_x = 4.0
var accel_x = 0.5

var speed_y = 0.0
var max_speed_y = 4
var accel_y = 0.25

var color_max = 255
var color_min = 110
onready var color_cur = modulate.r
var color_change = -4

func _process(delta):
	color_cur += color_change
	if color_cur >= color_max:
		color_cur = color_max
		color_change = -abs(color_change)
	elif color_cur <= color_min:
		color_cur = color_min
		color_change = abs(color_change)
	modulate.r = color_cur / 255.0
	modulate.g = color_cur / 255.0
	
	if (speed_x < max_speed_x):
		speed_x += accel_x
	if (abs(speed_y) <= abs(max_speed_y)):
		speed_y += accel_y
	else:
		speed_y = max_speed_y
		accel_y *= -1
	position += Vector2(-speed_x, speed_y)
