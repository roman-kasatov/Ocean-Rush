extends Node2D

onready var Game = get_parent()
onready var Player = Game.get_node("Player")


var lines = 15
var columns = 3
var min_in_column = 5
var max_in_column = 8
var dist_betw_lines = 80.0
var dist_betw_columns = 170.0
var last_plat
var dist_from_player = 500

enum types_pl {BASIC, BROKEN, CHIPPED, CHIPPED_UP, CHIPPED_DOWN, CRAB, JUMP} # 0, 1, ...

#у кого сумма не равна 1, тот еблан!
var chance_pl = {
	types_pl.BASIC : 0.5, 
	types_pl.BROKEN : 0.1,
	types_pl.CHIPPED : 0.1, 
	types_pl.CHIPPED_UP : 0.1, 
	types_pl.CHIPPED_DOWN : 0.1, 
	types_pl.CRAB : 0.05,
	types_pl.JUMP : 0.05
}

var nodes_pl = {
	types_pl.BASIC : preload("res://scenes/platforms/Platform_standart.tscn"),
	types_pl.BROKEN : preload("res://scenes/platforms/Platform_broken.tscn"),
	types_pl.CHIPPED : preload("res://scenes/platforms/Platform_chipped.tscn"),
	types_pl.CHIPPED_UP : preload("res://scenes/platforms/Platform_chipped_up.tscn"),
	types_pl.CHIPPED_DOWN : preload("res://scenes/platforms/Platform_chipped_down.tscn"),
	types_pl.CRAB : preload("res://scenes/platforms/Platform_crab.tscn"),
	types_pl.JUMP : preload("res://scenes/platforms/Platform_jump.tscn")
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
			for type in types_pl:
				if rnd < chance_pl[types_pl[type]]:
					section[ind][j] = types_pl[type]
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
			var plat = nodes_pl[section[i][j]].instance()
			plat.position = position + Vector2(j * dist_betw_columns, i * dist_betw_lines)
			Game.add_child(plat)
	position.x += dist_betw_columns * columns


func _ready():
	Player.height_to_fail = lines * dist_betw_lines + 400
	for type in range(1, len(types_pl)):
		chance_pl[type] += chance_pl[type - 1]
