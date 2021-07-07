extends TabContainer

var active = true

func start_game():
	active = false
	visible = false


func _on_Game_start_game():
	pass # Replace with function body.

func _ready():
	Events.connect('skin_panel_tab_switch', self, 'set_tab')

func set_tab(code):
	current_tab = code
