extends Node2D

onready var Game = get_parent()
onready var Player = Game.get_node("Player")
var Platform_standart = preload("res://scenes/Platform_standart.tscn")
var Platform_broken = preload("res://scenes/Platform_broken.tscn")
var Platform_chipped = preload("res://scenes/Platform_chipped.tscn")
var Platform_chipped_up = preload("res://scenes/Platform_chipped_up.tscn")
var Platform_chipped_down = preload("res://scenes/Platform_chipped_down.tscn")
var Platform_crab = preload("res://scenes/Platform_crab.tscn")

var chance = {"platform_basic" : 0.4, "platform_broken" : 0.2, "platform_chipped" : 0.2}
var lines = 10
var columns = 30
var dist_betw_lines = 80.0
var dist_betw_columns = 220.0
var plat_min = 2
var plat_max = 7
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
			section[i][j] = (i+j) % 6 + 1
			"""
			if (randf() <= chance["platform_basic"]):
				continue
			if (randf() <= chance["platform_broken"]):
				section[i][j] = 2
			else:
				section[i][j] = 1
			"""
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
			if (section[i][j] == 3):
				plat = Platform_chipped.instance()
			if (section[i][j] == 4):
				plat = Platform_chipped_up.instance()
			if (section[i][j] == 5):
				plat = Platform_chipped_down.instance()
			if (section[i][j] == 6):
				plat = Platform_crab.instance()
			plat.position = position + Vector2(j * dist_betw_columns, i * dist_betw_lines)
			Game.add_child(plat)


func _ready():
	#place_section()
	pass
