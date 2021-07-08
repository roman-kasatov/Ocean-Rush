extends Node2D

onready var Game = get_parent()
onready var Player = Game.get_node("Player")

var chance_bn = {
	'shield_bonus': 0.1,
	'jump_bonus': 0.1,
	'jetpack_bonus': 0.08
} # sum should be less or equal than 1

var chances_coins_spawner_1 = {
	'coin1': 0.4,
	'coin2': 0.4,
	'coin4': 0.15,
	'coin8': 0.05
} # sum should be less or equal than 1

var chances_coins_spawner_2 = {
	'coin1': 0,
	'coin2': 0.5,
	'coin4': 0.4,
	'coin8': 0.1
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

onready var Coin = preload("res://scenes/bonuses/Coin.tscn")

var chances_having_coins = {
	types_pl.BASIC : 1,
	types_pl.BROKEN : 0,
	types_pl.CHIPPED : 0, 
	types_pl.CHIPPED_UP : 0, 
	types_pl.CHIPPED_DOWN : 0, 
	types_pl.CRAB : 0,
	types_pl.JUMP : 0
} # sum should be less or equal than 1

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

var shark_spawn_chance = 0.5

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

var shark = preload("res://scenes/enemies/Shark_av.tscn")


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
		if (randf() < shark_spawn_chance):
			place_enemy()


func place_enemy():
	var enemy = shark.instance()
	var view_size = get_viewport_rect().size
	# coourds accounting Player's scale = 2	
	enemy.position = Vector2(0.18 * view_size.x, (randf() - 0.5) * 140)
	enemy.coord_const = Player.position.y
	Player.add_child(enemy)

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
				place_coins(plat, chances_having_coins[plat_type])
	position.x += dist_betw_columns * columns

func place_coins(plat, chance):
	if chance - randf() < 0:
		return
	var spawner = randi() % plat.get_node("CoinSpawners").get_child_count()
	#print(plat.get_child_count())
	for i in range(0, plat.get_node("CoinSpawners").get_child(spawner).get_child_count()):
		var coin = Coin.instance()
		chance = randf()
		var chances = chances_coins_spawner_1
		if coin.is_in_group("CoinSpawnerLevel1"):
			chances = chances_coins_spawner_1
		if coin.is_in_group("CoinSpawnerLevel2"):
			chances = chances_coins_spawner_2
		for j in chances.keys():
			chance -= chances[j]
			if chance < 0:
				coin.initiate(j)
				break
		#coin.position = i.position
		plat.get_node("CoinSpawners").get_child(spawner).get_child(i).add_child(coin)

func _ready():
	Player.height_to_fail = lines * dist_betw_lines + 600
	var sum = 0.0
	for i in len(chance_pl):
		sum += chance_pl[i]
	for i in len(chance_pl):
		chance_pl[i] /= sum
	for type in range(1, len(types_pl)):
		chance_pl[type] += chance_pl[type - 1]
