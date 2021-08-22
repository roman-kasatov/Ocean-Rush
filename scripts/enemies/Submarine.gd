extends AnimatedSprite

var speed_x = 1.0
var max_speed_x = 3.0
var accel_x = 0.5


func _process(delta):
	if (speed_x < max_speed_x):
		speed_x += accel_x
	position += Vector2(-speed_x, 0)
