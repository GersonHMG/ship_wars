extends Area2D

var	speed = 1000
var velocity = Vector2(0,0)
var damage = 10
var enemy_team = "enemies"
var distance = 0

func _ready():
	pass # Replace with function body.

func setup(_dir, pos, enemy):
	rotation = _dir.angle()
	position = pos
	velocity = _dir*speed
	enemy_team = enemy

func _physics_process(delta):

	self.position += velocity*delta
	distance += velocity.length()*delta
	if distance > 300:
		self.queue_free()

func _on_RedLaser_body_entered(body):
	if body.is_in_group(enemy_team):
		if body.has_method("damage"):
			body.damage(damage)
			$AnimatedSprite.visible = true
			$AnimatedSprite.play("explotion")
			velocity = Vector2(0,0)

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	self.queue_free()
