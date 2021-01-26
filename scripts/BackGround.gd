extends Node2D

var speed = 0.5
var mood : float = 0
var loop_scale = 7

onready var AR1 = $CanvasModulate/AbstractRects
onready var AR2 = $CanvasModulate/AbstractRects2
onready var AR3 = $CanvasModulate/AbstractRects3


func _physics_process(delta):
	mood = (mood + delta * speed)
	AR1.position = Vector2(cos(mood), sin(mood)) * loop_scale
	AR2.position = Vector2(cos(2 * mood), sin(2 * mood)) * loop_scale
	AR3.position = Vector2(cos(3 * mood), sin(3 * mood)) * loop_scale
