extends RayCast2D

onready var ship = get_parent().get_parent() #sprite ship
var steer_force = 1
var can_shoot = false
var target = null
var enemy = ""
var turret_angle = PI/4

func _physics_process(delta):
	if target != null:
		pointing(target.position)
	if self.is_colliding():
		if self.get_collider().is_in_group(enemy):
			shoot(enemy)

func pointing(tg):
	var target = tg- self.global_position
	var angle = Vector2(1,0).rotated(ship.global_rotation).angle_to(target) + PI/2
	var m_rotation = clamp(lerp_angle(self.rotation,angle,0.1), -turret_angle,turret_angle) 
	self.rotation = m_rotation


#Dispara un simple proyectil
func shoot(enemy):
	if can_shoot:
		can_shoot = false
		var projectile = load("res://scenes/entities/projectiles/RedLaser.tscn").instance()
		var dir = Vector2(1,0).rotated(self.global_rotation - PI/2)
		projectile.setup(dir, $gun_pos.global_position, enemy)
		ship.get_parent().get_parent().get_parent().add_child(projectile)	#!!!CAMBIAR ESTO

#============================SIGNALS=======================#

func _on_rate_timeout():
	can_shoot = true
