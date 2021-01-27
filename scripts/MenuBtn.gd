extends Button

func _pressed():
	if get_parent().get_parent().active:
		get_tree().paused = false
		get_tree().reload_current_scene()
