extends Sprite

var need_to_erase = false

var speed = 0.0
var max_speed = 0.3
var accel = 0.02


func _physics_process(delta):
	speed += accel
	if (abs(speed) > abs(max_speed)):
		accel = -accel
	position.y += speed
	
	if (need_to_erase):
		modulate.a -= 0.03
		if (modulate.a <= 0):
			queue_free()
