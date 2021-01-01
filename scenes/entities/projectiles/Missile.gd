extends Area2D

var current_target = null

var enemy = ""

#=Variables fisicas
var velocity = Vector2(0,0)
var acceleration = Vector2(0,0)
var steer_force = 1
var speed = 200
#=Variables del proyectil
var damage = 20
var distance = 0


func setup(target, spawn, enm):
	current_target = target
	position = spawn
	enemy = enm

func _physics_process(delta):
	if current_target != null:
		acceleration = steering(current_target)
	else:
		self.queue_free()
	self.position += velocity*delta
	distance += velocity.length()*delta
	if distance > 30:
		explode()
	movement(delta)
	
func movement(delta):
	velocity += acceleration
	velocity.clamped(speed)
	self.rotation = velocity.angle()
	self.global_position += velocity

func steering(target):
	var d_velocity = (target.global_position - self.global_position).normalized()*speed
	var steering = (d_velocity - velocity).normalized()*steer_force
	return steering

func _on_Missile_body_entered(body):
	if body.is_in_group(enemy):
		if body.has_method("damage"):
			body.damage(damage)
			explode()

func explode():
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("explotion")
	velocity = Vector2(0,0)
	speed = 0

func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	self.queue_free()
