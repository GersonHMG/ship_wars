extends Camera2D

var target = null

func _physics_process(delta):
	if target:
		self.global_position = target.global_position

func _ready():
	pass 



