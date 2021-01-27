extends Label

var time_for_score = 1.0

onready var Game = get_parent().get_parent()
var timer

func add_points():
	var curr = int(text)
	curr = curr + 1
	text = str(curr)


func _ready():
	print(rect_position)
	text = "0"
	timer = Timer.new()
	timer.wait_time = time_for_score
	timer.one_shot = false
	add_child(timer)
	timer.connect("timeout", self, "add_points")
