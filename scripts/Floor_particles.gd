extends CPUParticles2D

var timer

func _ready():
	emitting = true
	timer = Timer.new()
	timer.wait_time = 10
	timer.autostart = true
	add_child(timer)
	timer.connect("timeout", self, "die")
	
func die():
	queue_free()
