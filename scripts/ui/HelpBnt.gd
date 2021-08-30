extends TextureButton

var GameHUD

func _ready():
	GameHUD = get_parent().get_parent()

func _pressed():
	GameHUD.show_help()
