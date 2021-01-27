extends Area2D



func _on_DetectorLeft_area_entered(area):
	area.get_parent().queue_free()
