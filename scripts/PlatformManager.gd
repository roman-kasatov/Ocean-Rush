extends Node2D

onready var Game = get_parent()
onready var Player = Game.get_node("Player")


#var Platform_standart = preload("res://scenes/Platform_standart.tscn")
#var Platform_broken = preload("res://scenes/Platform_broken.tscn")
#var chance = {"platform_basic" : 0.4, "platform_broken" : 0.1}

var lines = 10
var columns = 3
var min_in_column = 3
var max_in_column = 4
var dist_betw_lines = 50.0
var dist_betw_columns = 170.0
var last_plat
var dist_from_player = 500

enum types {BASIC, BROKEN, CHIPPED, CHIPPED_UP, CHIPPED_DOWN, CRAB} # 0, 1, ...

# sum should be equal zero
var chance = {
	types.BASIC : 0.4, 
	types.BROKEN : 0.6,
	types.CHIPPED : 0.0, 
	types.CHIPPED_UP : 0.0, 
	types.CHIPPED_DOWN : 0.0, 
	types.CRAB : 0.0
}

var nodes = {
	types.BASIC : preload("res://scenes/Platform_standart.tscn"),
	types.BROKEN : preload("res://scenes/Platform_broken.tscn"),
	types.CHIPPED : preload("res://scenes/Platform_chipped.tscn"),
	types.CHIPPED_UP : preload("res://scenes/Platform_chipped_up.tscn"),
	types.CHIPPED_DOWN : preload("res://scenes/Platform_chipped_down.tscn"),
	types.CRAB : preload("res://scenes/Platform_crab.tscn")
}

func generate_section():
	var line = []
	var section = []
	for i in range(columns):
		line.push_back(-1) # -1 is nothing
	for i in range(lines):
		section.push_back(line.slice(0, columns))

	for j in range(columns):
		var quant = min_in_column + randi() % (max_in_column - min_in_column + 1)
		for t in range(quant):
			var ind = randi() % lines
			while not section[ind][j] == -1:
				ind = (ind + 1) % lines

			var rnd = randf()
			for type in types:
				if rnd < chance[types[type]]:
					section[ind][j] = types[type]
					break
	return section

func _physics_process(delta):
	if position.x < Player.position.x + dist_from_player:
		place_section()

func place_section():
	var section = generate_section()
	for i in range(lines):
		for j in range(columns):
			if (section[i][j] == -1):
				continue
			var plat = nodes[section[i][j]].instance()
			plat.position = position + Vector2(j * dist_betw_columns, i * dist_betw_lines)
			Game.add_child(plat)
	position.x += dist_betw_columns * columns

func _ready():
	for type in range(1, len(types)):
		chance[type] += chance[type - 1]
