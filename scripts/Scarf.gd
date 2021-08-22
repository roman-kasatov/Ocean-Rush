extends Node2D

var length = 300
var length_add = 0
var constrain : float = 5
var gravity = Vector2(0, 4)
var friction_x = 0
var friction_y = 0.2
var friction_mult = 10
var start_pin = true
var end_pin = false

var pos: PoolVector2Array
var pos_ex: PoolVector2Array
var count: int

func _ready():
	# texture has height 80 px and width about 150-300
	var scarf_texture = load("res://drawable/scarfs/flag_abstr_7.png")
	$Line2D.texture = scarf_texture
	# 80 is a scarf heigth === width, 
	# I really don't know why it should be devided by 2
	if scarf_texture.get_size().x == 1:
		length_add = 129
	length = 80 * scarf_texture.get_size().x / scarf_texture.get_size().y / 2 + length_add
	
	count = get_count(length)
	resize_arrays()
	init_position()

func get_count(length: float):
	var new_count = ceil(length / constrain)
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
	for i in range(count - 1):
		var distance = pos[i].distance_to(pos[i+1])
		var delta = pos[i + 1] - pos[i]
		pos[i + 1] = pos[i] + delta * constrain / distance
		
func set_start_point(position):
	pos[0] = position
	pos_ex[0] = position

func calculate_friction(p1, p2):
	var delta = p1 - p2
	delta.x *= friction_x
	delta.y *= friction_y
	return delta
