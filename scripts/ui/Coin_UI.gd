extends AnimatedSprite

onready var blicking = $Coin_blicking

func _ready():
	playing = true
	blicking.playing = true
	
