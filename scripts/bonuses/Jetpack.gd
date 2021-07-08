extends Sprite

onready var Particles = preload("res://scenes/particles/particles_jetpack_falling.tscn")
onready var Jetpack_with_fuel = preload("res://drawable/Character/jetpack_with_fuel.png")
onready var Jetpack_without_fuel = preload("res://drawable/Character/jetpack.png")
onready var Player = get_parent()

onready var Fuel = $Fuel
onready var Fire = Player.get_node("Fire")

onready var working = 0

func appear():
	Fuel.playing = false
	Fuel.frame = 0
	visible = true

func disappear():
	if !visible:
		return
	working = 0
	var particles = Particles.instance()
	if (Fuel.frame == 0):
		particles.texture = Jetpack_with_fuel
	else:
		particles.texture = Jetpack_without_fuel
	particles.emitting = true
	particles.position = get_global_position() + Vector2(0, 16)
	Player.get_parent().add_child(particles)
	visible = false

func launch():
	if Fuel.playing:
		return
	Fuel.playing = true
	Fire.emitting = true
	working = 1

func _on_Fuel_animation_finished():
	Player.can_pick = 1
	disappear()

func _on_Fuel_frame_changed():
	if Fuel.frame == 13:
		Fire.emitting = false
