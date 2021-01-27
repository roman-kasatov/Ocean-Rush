extends TextureButton

signal pause_pressed

func _pressed():
	get_tree().paused = true
	emit_signal("pause_pressed")
