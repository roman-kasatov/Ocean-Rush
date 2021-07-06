extends AnimatedSprite

onready var Particles = preload("res://scenes/particles/particles_bubble_explosion.tscn")
onready var Player = get_parent()

func appear():
	self.visible = true

func disappear():
	if !visible:
		return
	var particles = Particles.instance()
	particles.emitting = true
	particles.position = get_global_position() + Vector2(0, 16)
	Player.get_parent().add_child(particles)
	self.visible = false
