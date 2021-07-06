extends Sprite

onready var Particles = preload("res://scenes/particles/particles_jetpack_falling.tscn")
onready var Player = get_parent()

onready var Fuel = $Fuel
onready var Fire = $Fire

func appear():
	Fuel.playing = false
	Fuel.frame = 0
	visible = true

func disappear():
	var particles = Particles.instance()
	particles.emitting = true
	particles.position = get_global_position() + Vector2(0, 16)
	Player.get_parent().add_child(particles)
	visible = false

func launch():
	if Fuel.playing:
		return
	Fuel.playing = true
	Fire.visible = true

func _on_Fuel_animation_finished():
	disappear()

func _on_Fuel_frame_changed():
	if Fuel.frame == 13:
		Fire.emitting = false
