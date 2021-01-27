extends TextureButton

var skin_type
var skin_numb

signal change_skin

func _pressed():
	emit_signal("change_skin", skin_type, skin_numb)
