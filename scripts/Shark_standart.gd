extends AnimatedSprite

var speed_x = 1.0
var max_speed_x = 5.0
var accel_x = 0.5

var speed_y = 0.0
var max_speed_y = 3
var accel_y = 0.15

func _process(delta):
	if (speed_x < max_speed_x):
		speed_x += accel_x
	if (abs(speed_y) <= abs(max_speed_y)):
		speed_y += accel_y
	else:
		speed_y = max_speed_y
		accel_y *= -1
	position += Vector2(-speed_x, speed_y)
	
