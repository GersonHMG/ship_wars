extends Area2D

var speed = 500
var direction = Vector2(0,0)
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	self.position += direction*speed*delta




func _on_Timer_timeout():
	self.queue_free()
