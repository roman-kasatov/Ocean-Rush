extends Area2D

onready var Particles = preload("res://scenes/particles/particles_bonus_explosion.tscn")
onready var Player = get_parent()

func _area_entered(area):
	if not(area.is_in_group("gatherable")):
		return
	var type = area.type
	if type in ['shield_bonus', 'jump_bonus', 'jetpack_bonus']:
		get_parent().add_bonus(type)
	elif type == 'coin':
		pass
	area.queue_free()
	var particles = Particles.instance()
	particles.emitting = true
	particles.position = area.get_global_position()#get_global_position() + Vector2(40, 16)
	Player.get_parent().add_child(particles)
