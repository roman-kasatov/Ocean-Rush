extends AnimatedSprite

onready var part = $CPUParticles2D2
var pos_y_saved : float
var rot_saved : float

var speed_x = 1.0
var max_speed_x = 6.0
var accel_x = 0.5

var speed_y = 0.0
var max_speed_y = 3
var accel_y = 0.15

var phase_rot = 0.0
var speed_rot = 0.15


func _process(delta):
	if (speed_x < max_speed_x):
		speed_x += accel_x
	if (abs(speed_y) <= abs(max_speed_y)):
		speed_y += accel_y
	else:
		speed_y = max_speed_y * sign(speed_y)
		accel_y *= -1
	position += Vector2(-speed_x, speed_y)
	phase_rot += speed_rot
	rotation = sin(phase_rot) / 7
	part.rotation = -rotation
