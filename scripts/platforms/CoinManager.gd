extends Node2D

onready var Game = get_parent()
onready var PlatformManager = Game.get_node("PlatformManagerManager")

var chances_coins_spawner_1 = {
	'coin1': 0.8,
	'coin2': 0.2,
	'coin4': 0,
	'coin8': 0
} # sum should be less or equal than 1

var chances_coins_spawner_2 = {
	'coin1': 0.2,
	'coin2': 0.5,
	'coin4': 0.2,
	'coin8': 0.1
} # sum should be less or equal than 1

onready var Coin = preload("res://scenes/bonuses/Coin.tscn")

enum types_pl {BASIC, BROKEN, CHIPPED, CHIPPED_UP, CHIPPED_DOWN, CRAB, JUMP}

var chances_having_coins = {
	types_pl.BASIC : 0.25,
	types_pl.BROKEN : 0,
	types_pl.CHIPPED : 0, 
	types_pl.CHIPPED_UP : 0, 
	types_pl.CHIPPED_DOWN : 0, 
	types_pl.CRAB : 0,
	types_pl.JUMP : 0
} # sum should be less or equal than 1



func place_coins(plat, type):
	var chance = chances_having_coins[type]
	if chance - randf() < 0:
		return
	var spawner_num = randi() % plat.get_node("CoinSpawners").get_child_count()
	var spawner = plat.get_node("CoinSpawners").get_child(spawner_num)
	for i in range(0, spawner.get_child_count()):
		var coin = Coin.instance()
		chance = randf()
		var chances = chances_coins_spawner_2
		if spawner.get_child(i).is_in_group("CoinSpawnerLevel1"):
			chances = chances_coins_spawner_1
		elif spawner.get_child(i).is_in_group("CoinSpawnerLevel2"):
			chances = chances_coins_spawner_2
		for j in chances.keys():
			chance -= chances[j]
			if chance < 0:
				coin.initiate(j)
				break
		spawner.get_child(i).add_child(coin)
