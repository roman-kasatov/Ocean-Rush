extends Label

var time_for_score = 1.0

onready var Game = get_parent().get_parent()
var timer

func add_points():
	var curr = int(text)
	curr = curr + 1
	text = str(curr)


func _ready():

