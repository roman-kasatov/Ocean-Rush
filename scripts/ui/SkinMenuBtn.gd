extends TextureButton

export (int) var code


func _ready():
	connect("button_up", self, 'click')

func click():
	Events.emit_signal('skin_panel_tab_switch', code)

