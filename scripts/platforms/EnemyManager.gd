extends Node2D

onready var Game = get_parent()
onready var Player = Game.get_node("Player")

var enemy_curr = 0
var can_spawn = 1

var shark = preload("res://scenes/enemies/Shark_av.tscn")
var jellyfish = preload("res://scenes/enemies/Jellyfish_warn.tscn")
var submarine = preload("res://scenes/enemies/Submarine_warn.tscn")

var wave = []
var player_posy = 0

var enemies_easy = [
	[[0, shark, 1.3], [0, shark, 2.0]]
]

var enemies_medium = [
]

var enemies_hard = [
]


func choose_waves(power):
	player_posy = Player.position.y
	can_spawn = 0
	var waves = enemies_easy
	if power == 2:
		waves = enemies_medium
	elif power == 3:
		waves = enemies_hard
	wave = waves[randi() % len(waves)]
	next_enemy()


func spawn_enemy():
	var to_spawn = wave[enemy_curr]
	var enemy = to_spawn[1].instance()
	var view_size = get_viewport_rect().size
	enemy.position = Vector2(0.18 * view_size.x, (randf() - 0.5) * 140 + to_spawn[0])
	enemy.coord_const = Player.position.y
	Player.add_child(enemy)
	return to_spawn[2]


func next_enemy():
	if enemy_curr >= len(wave):
		enemy_curr = 0
		can_spawn = 1
	else:
		var timer = Timer.new()
		timer.autostart = true
		timer.one_shot = true
		timer.connect("timeout", self, "next_enemy")
		add_child(timer)
		timer.wait_time = spawn_enemy()
		enemy_curr += 1

