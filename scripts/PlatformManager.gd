extends Node2D

onready var Game = get_parent()
onready var Player = Game.get_node("Player")
var Platform_standart = preload("res://scenes/Platform_standart.tscn")
var Platform_broken = preload("res://scenes/Platform_broken.tscn")

var chance = {"platform_basic" : 0.4, "platform_broken" : 0.1}
var lines = 10
var columns = 3
var dist_betw_lines = 50.0
var dist_betw_columns = 170.0
var last_plat


func generate_section():
	var line = []
	var section = []
	for i in range(columns):
		line.push_back(0)
	for i in range(lines):
		section.push_back(line.slice(0, columns))
	
	for i in range(lines):
		for j in range(columns):
			if (randf() <= chance["platform_basic"]):
				continue
			if (randf() <= chance["platform_broken"]):
				section[i][j] = 2
			else:
				section[i][j] = 1
	
	return section


func place_section():
	var section = generate_section()
	for i in range(lines):
		for j in range(columns):
			if (section[i][j] == 0):
				continue
			var plat
			if (section[i][j] == 1):
				plat = Platform_standart.instance()
			if (section[i][j] == 2):
				plat = Platform_broken.instance()
			plat.position = position + Vector2(j * dist_betw_columns, i * dist_betw_lines)
			Game.add_child(plat)


func _ready():
	#place_section()
	pass
