extends AnimatedSprite

var speed = 1.0
var max_speed = 5.0
var accel = 0.5

func _process(delta):
	if (speed < max_speed):
		speed += accel
	position.x -= speed
