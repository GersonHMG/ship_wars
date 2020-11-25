extends Area2D

var	speed = 1000
var velocity = Vector2(0,0)
var damage = 10
var enemy_team = "enemies"

func _ready():
	pass # Replace with function body.

func setup(_dir, _speed, pos, enemy):
	speed += _speed
	rotation = _dir.angle()
	position = pos
	velocity = _dir*speed
	enemy_team = enemy

func _physics_process(delta):
	self.position += velocity*delta

func _on_Timer_timeout():
	self.queue_free()


func _on_RedLaser_body_entered(body):
	if body.is_in_group(enemy_team):
		if body.has_method("damage"):
			body.damage(damage)
			self.queue_free()
