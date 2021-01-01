extends Line2D


onready var thruster = self.get_parent()

var point
var trail_length = 30



func _physics_process(delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	if thruster:
		point = thruster.global_position
		add_point(point)
		while get_point_count() > trail_length:
			self.remove_point(0)
