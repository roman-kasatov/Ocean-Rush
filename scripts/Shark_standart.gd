extends AnimatedSprite

var speed = 5.0
var accel = 1.0

func _process(delta):
	speed += accel
	position.x -= speed
