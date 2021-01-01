extends Sprite


var current_target = null

func init(tg):
	current_target = tg

func _physics_process(delta):
	if current_target != null:
		self.global_position = current_target.global_position
	else:
		queue_free()


