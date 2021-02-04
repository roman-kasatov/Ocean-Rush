extends Node2D

var length = 300
var constrain = 20
var gravity = Vector2(0, 4)
var friction = 0.5
var friction_mult = 10
var start_pin = true
var end_pin = false

var pos: PoolVector2Array
var pos_ex: PoolVector2Array
var count: int

func _ready():
	count = get_count(length)
	resize_arrays()
	init_position()
	$Line2D.texture = load("res://drawable/flag_rf.png")

func get_count(distance: float):
	var new_count = ceil(distance / constrain)
	return new_count

func resize_arrays():
	pos.resize(count)
	pos_ex.resize(count)

func init_position():
	for i in range(count):
		pos[i] = position - Vector2(constrain * i, 0)
		pos_ex[i] = position - Vector2(constrain * i, 0)
	position = Vector2.ZERO

func _physics_process(delta):
	update_points(delta)
	update_distance()
	$Line2D.points = pos

func update_points(delta):
	for i in range (count):
		if (i!=0 && i!=count-1) || (i==0 && !start_pin) || (i==count-1 && !end_pin):
			var vec2 = calculate_friction(pos[i], pos_ex[i])
			pos_ex[i] = pos[i]
			pos[i] += vec2 + (gravity * delta)

func update_distance():
	for i in range(count):
		if i == count-1:
			return
		var distance = pos[i].distance_to(pos[i+1])
		var difference = constrain - distance
		var percent = difference / distance
		var vec2 = pos[i+1] - pos[i]
		if i == 0:
			if start_pin:
				pos[i+1] += vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
		elif i == count-1:
			pass
		else:
			if i+1 == count-1 && end_pin:
				pos[i] -= vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
				
func set_start_point(position):
	pos[0] = position
	pos_ex[0] = position

func calculate_friction(p1, p2):
	return atan(friction_mult * (p1 - p2).length()) * (p1 - p2) * friction
