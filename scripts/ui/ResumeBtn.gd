extends Button

func _pressed():
	if get_parent().get_parent().active:
		get_parent().get_parent().visible = false
		get_parent().get_parent().active = false
		get_tree().paused = false
		
