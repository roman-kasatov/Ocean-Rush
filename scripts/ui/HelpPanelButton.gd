extends Button

var GameHUD
onready var Game = get_node("/root/Game")

func _ready():
	GameHUD = get_parent().get_parent()

func _pressed():
	GameHUD.hide_help()
	Game.set_help_shown()
