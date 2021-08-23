extends Area2D

onready var Particles_bonus = preload("res://scenes/particles/particles_bonus_explosion.tscn")
onready var Particles_coin = preload("res://scenes/particles/particles_coin_gather.tscn")
onready var Player = get_parent()
onready var Game = Player.get_parent()

var particles : CPUParticles2D

func _area_entered(area):
	if not(area.is_in_group("gatherable")):
		return
	if !Player.can_pick and !area.is_in_group("money"):
		return
	var type = area.type
	if type in ['shield_bonus', 'jump_bonus', 'jetpack_bonus']:
		particles = Particles_bonus.instance()
		get_parent().add_bonus(type)
	elif type == 'coin':
		particles = Particles_coin.instance()
		particles.modulate = area.get_node("AnimatedSprite").modulate
		var balance = int(Game.Coins.text)
		balance += area.value
		Game.Coins.text = str(balance)
		Game.add_coin(area.value)
	area.queue_free()
	particles.emitting = true
	particles.position = area.get_global_position()#get_global_position() + Vector2(40, 16)
	Player.get_parent().add_child(particles)
