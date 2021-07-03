extends Area2D

func _area_entered(area):
	if area.is_in_group("gatherable"):
		var type = area.type
		if type in ['shield_bonus', 'jump_bonus']:
				get_parent().add_bonus(type)
		elif type == 'coin':
			pass
		area.queue_free()
