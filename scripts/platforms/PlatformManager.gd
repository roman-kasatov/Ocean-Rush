extends Node2D

onready var Game = get_parent()
onready var Player = Game.get_node("Player")


var lines = 15
var columns = 3
var min_in_column = 5
var max_in_column = 8
var dist_betw_lines = 80.0
var dist_betw_columns = 250.0
var dist_from_player = 500
var last_plat
var enemy_type

enum types_pl {BASIC, BROKEN, CHIPPED, CHIPPED_UP, CHIPPED_DOWN, CRAB, JUMP}
enum types_en {SHARK}

# the values are relative
var chance_pl = {
	types_pl.BASIC : 10, 
	types_pl.BROKEN : 2,
	types_pl.CHIPPED : 2, 
	types_pl.CHIPPED_UP : 2, 
	types_pl.CHIPPED_DOWN : 2, 
	types_pl.CRAB : 1,
	types_pl.JUMP : 1
}

var chance_en = {
	types_en.SHARK : 0.5
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

var nodes_en = {
	types_en.SHARK : preload("res://scenes/Shark_av.tscn")
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
		place_enemy()


func place_enemy():
	if (randf() < chance_en[types_en.SHARK]):
		var enemy = nodes_en[types_en.SHARK].instance()
		enemy.position = Vector2(180, 0)
		enemy.coord_const = Player.position.y
		Player.add_child(enemy)


func place_section():
	var section = generate_section()
	for i in range(lines):
		for j in range(columns):
			if (section[i][j] == -1):
				continue
			var plat = nodes_pl[section[i][j]].instance()
			var additional_pos = Vector2((randf() - 0.5) * 40, (randf() - 0.5) * 40)
			plat.position = position + Vector2(j * dist_betw_columns, i * dist_betw_lines) + additional_pos
			Game.add_child(plat)
	position.x += dist_betw_columns * columns


func _ready():
	Player.height_to_fail = lines * dist_betw_lines + 400
	var sum = 0.0
	for i in len(chance_pl):
		sum += chance_pl[i]
	for i in len(chance_pl):
		chance_pl[i] /= sum
	print(chance_pl)
	for type in range(1, len(types_pl)):
		chance_pl[type] += chance_pl[type - 1]
