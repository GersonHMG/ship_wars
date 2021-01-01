extends Area2D



func _ready():
	pass # Replace with function body.

func _process(delta):
	self.global_position = get_global_mouse_position()

