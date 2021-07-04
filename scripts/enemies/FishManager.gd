extends Node2D

onready var Game = get_parent().get_parent()
onready var Player = Game.get_node("Player")
onready var PlatformManager = Game.get_node("PlatformManager")
onready var Canvas = Game.get_node("CanvasLayer")
onready var DarkScreen = preload("res://scenes/enemies/Dark_Screen.tscn")#Player.get_node("Dark_Screen")
onready var Fish = preload("res://scenes/enemies/Fish.tscn")

var timer : Timer

var fish_chance = 0.2
var sections_without_fish = 8

var sharks_count = 8
var sharks_time = 0.4
var sharks_left = 0

var speedup_rate = 200
var speedup_time = 4.5
var saved_rate

var sections_of_broken = 3

var sections_of_crab = 1

var dark_screen_time = 9.0
var dark_screen

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)

func create_danger_sharks():
	sharks_left = sharks_count
	timer.wait_time = sharks_time
	timer.connect("timeout", self, "add_shark")
	timer.start()

func create_danger_speedup():
	saved_rate = Game.rate
	Game.rate = speedup_rate
	timer.wait_time = speedup_time
	timer.connect("timeout", self, "change_time_to_saved")
	#Player.change_anim_scared(speedup_time + 0.3) #пофиксить
	timer.start()

func create_danger_broken_platforms():
	PlatformManager.section_cnt_of_broken_pl = sections_of_broken

func create_danger_crab_platforms():
	PlatformManager.section_cnt_of_crab_pl = sections_of_crab

func create_danger_dark_screen():
	timer.wait_time = dark_screen_time
	timer.connect("timeout", self, "make_dark_screen_invisible")
	dark_screen = DarkScreen.instance()
	dark_screen.position = Vector2(60, 20)
	dark_screen.scale = Vector2(1.2, 0.67)
	Player.add_child(dark_screen)
	#Player.change_anim_scared(dark_screen_time + 0.3)
	timer.start()

func create_danger_fishes():
	print("screen size = ", get_viewport_rect()) 
	var fish_up = Fish.instance()
	var fish_down = Fish.instance()
	fish_up.type = "up"
	fish_down.type = "down"
	var view_size = get_viewport_rect().size
	var v_shift : float = view_size.y / 5
	fish_up.position_start = Vector2(0.9 * view_size.x, 0.13 * view_size.y - v_shift)
	fish_down.position_start = Vector2(0.9 * view_size.x, 0.87 * view_size.y + v_shift)
	fish_up.position_designated = Vector2(0.9 * view_size.x, 0.13 * view_size.y)
	fish_down.position_designated = Vector2(0.9 * view_size.x, 0.87 * view_size.y)	
	Canvas.add_child(fish_up)
	Canvas.add_child(fish_down)

func add_shark():
	PlatformManager.place_enemy()
	if (sharks_left):
		sharks_left -= 1
		timer.start()
	else:
		timer.disconnect("timeout", self, "add_shark")

func change_time_to_saved():
	Game.rate = saved_rate
	timer.disconnect("timeout", self, "change_time_to_saved")

func make_dark_screen_invisible(): #убедись, что в случае смерти он убирается + сделать его плавное затемнение
	dark_screen.delete()
	timer.disconnect("timeout", self, "make_dark_screen_invisible")
