extends Node2D

onready var Game = get_parent()
onready var Player = Game.get_node("Player")

var last_wave = -1
var score_for_medium = 35
var score_for_hard = 80

var enemy_curr = 0
var can_spawn = 1

var shark = preload("res://scenes/enemies/Shark_av.tscn")
var jellyfish = preload("res://scenes/enemies/Jellyfish_warn.tscn")
var submarine = preload("res://scenes/enemies/Submarine_warn.tscn")

var wave = []
var player_posy = 0

var enemies_spawn_chance = 0.5

var enemies_easy = [
	[[0, shark, 1.0]],
	[[0, shark, 1.3], [0, shark, 2.0]],
	[[0, shark, 1.3], [0, jellyfish, 2.0, 3]],
	[[0, jellyfish, 1.5, 5]], 
	[[60, shark, 0.001], [-60, shark, 2.5]],
	[[-60, jellyfish, 0.001, 2], [60, jellyfish, 2.0, 2]]
]

var enemies_medium = [
	[[60, shark, 1.2], [60, shark, 0.001], [-60, shark, 1.2], [60, shark, 2.8]],
	[[60, jellyfish, 0.001, 4], [-60, jellyfish, 1.5, 4]],
	[[0, jellyfish, 2.0, 10]],
	[[0, submarine, 2.5]],
	[[0, submarine, 2.5]],
	[[0, submarine, 2.5]],
	[[0, shark, 0.001], [-60, jellyfish, 2.0, 4]]
]

var enemies_hard = [
	[[0, shark, 0.001], [60, shark, 0.001], [-60, shark, 3.0]],
	[[0, jellyfish, 0.001, 5], [60, jellyfish, 0.001, 5], [-60, jellyfish, 3.0, 5]],
	[[0, submarine, 1.5], [60, jellyfish, 0.001, 5], [-60, jellyfish, 3.0, 5]],
	[[0, submarine, 1.5], [60, jellyfish, 0.001, 5], [-60, jellyfish, 3.0, 5]],
	[[0, shark, 1.3], [0, shark, 1.3], [0, shark, 3.0]],
	[[0, shark, 1.3], [0, jellyfish, 1.5, 6], [0, shark, 3.0]],
	[[0, jellyfish, 3.0, 11]]
]


func begin_wave():
	if !can_spawn:
		return
	if randf() > enemies_spawn_chance:
		return
	if Game.score >= score_for_hard:
		choose_waves(enemies_hard)
	elif Game.score >= score_for_medium:
		choose_waves(enemies_medium)
	else:
		choose_waves(enemies_easy)


func choose_waves(waves):
	player_posy = Player.position.y
	can_spawn = 0
	var wave_ind = last_wave
	while wave_ind == last_wave:
		wave_ind = randi() % len(waves)
	last_wave = wave_ind
	wave = waves[wave_ind]
	next_enemy()


func spawn_enemy():
	var to_spawn = wave[enemy_curr]
	var enemy = to_spawn[1].instance()
	if to_spawn[1] == jellyfish:
		enemy.spawns_left = to_spawn[3]
	var view_size = get_viewport_rect().size
	enemy.position = Vector2(0.18 * view_size.x, (randf() - 0.5) * 140)
	enemy.coord_const = Player.position.y + to_spawn[0]
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
		timer.wait_time = spawn_enemy()
		add_child(timer)
		enemy_curr += 1
