extends Node2D

onready var Game = get_parent()
onready var Player = Game.get_node("Player")
onready var CoinManager = Game.get_node("CoinManager")
onready var EnemyManager = Game.get_node("EnemyManager")

var chance_bn = {
	'shield_bonus': 0.025,
	'jump_bonus': 0.018,
	'jetpack_bonus': 0.015
} # sum should be less or equal than 1

var lines = 15
var columns = 3
var min_in_column = 6
var max_in_column = 9
var dist_betw_lines = 80.0
var dist_betw_columns = 250.0
var dist_from_player = 500
var last_plat
var enemy_type

var section_cnt_of_broken_pl = 0
var section_cnt_of_crab_pl = 0

enum types_pl {BASIC, BROKEN, CHIPPED, CHIPPED_UP, CHIPPED_DOWN, CRAB, JUMP}

var bonus_platforms = [
	types_pl.BASIC, 
	types_pl.BROKEN,
	types_pl.CHIPPED
]

var chance_pl = {
	types_pl.BASIC : 9, 
	types_pl.BROKEN : 4,
	types_pl.CHIPPED : 2, 
	types_pl.CHIPPED_UP : 1, 
	types_pl.CHIPPED_DOWN : 1, 
	types_pl.CRAB : 1,
	types_pl.JUMP : 1
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

var Bonus = preload("res://scenes/bonuses/Bonus.tscn")


func generate_section():
	var line = []
	var section = []
	for _i in range(columns):
		line.push_back(-1) # -1 is nothing
	for _i in range(lines):
		section.push_back(line.slice(0, columns))

	for j in range(columns):
		var quant = min_in_column + randi() % (max_in_column - min_in_column + 1)
		for _t in range(quant):
			var ind = randi() % lines
			while not section[ind][j] == -1:
				ind = (ind + 1) % lines

			if (section_cnt_of_broken_pl):
				section[ind][j] = 1
				continue
			elif (section_cnt_of_crab_pl):
				section[ind][j] = 5
				continue

			var rnd = randf()
			for type in types_pl:
				if rnd < chance_pl[types_pl[type]]:
					section[ind][j] = types_pl[type]
					break
	if (section_cnt_of_broken_pl):
		section_cnt_of_broken_pl -= 1
	if (section_cnt_of_crab_pl):
		section_cnt_of_crab_pl -= 1
	return section


func _physics_process(_delta):
	if position.x < Player.position.x + dist_from_player:
		place_section()
		EnemyManager.begin_wave()


func place_section():
	var section = generate_section()
	for i in range(lines):
		for j in range(columns):
			var plat_type = section[i][j]
			if (plat_type == -1):
				continue
			var plat = nodes_pl[plat_type].instance()
			var additional_pos = Vector2(132 * (i % 2), 0)
			plat.position = position + Vector2(j * dist_betw_columns, i * dist_betw_lines) + additional_pos
			Game.add_child(plat)
			var chance = randf()
			if plat_type in bonus_platforms:
				for bn_type in chance_bn:
					chance -= chance_bn[bn_type]
					if chance < 0:
						var bonus = Bonus.instance()
						bonus.initiate(bn_type)
						bonus.position = plat.position + Vector2(0, -64)
						Game.add_child(bonus)
						break
			if chance >= 0: #если нет бонуса
				CoinManager.place_coins(plat, plat_type)
	position.x += dist_betw_columns * columns

func _ready():
	Player.height_to_fail = lines * dist_betw_lines + 600
	var sum = 0.0
	for i in len(chance_pl):
		sum += chance_pl[i]
	for i in len(chance_pl):
		chance_pl[i] /= sum
	for type in range(1, len(types_pl)):
		chance_pl[type] += chance_pl[type - 1]
