extends RayCast2D


signal null_target(weapon)



onready var WeaponManager = get_parent().get_parent()
onready var parent = get_parent()
#OJO CON ESTO!!
onready var bullet_spawn = WeaponManager.get_parent().get_parent()
#onready var bullet_spawn = parent.get_parent().get_parent().get_parent()
#Velocidad con la que gira
var steer_force = 1
#Maximo angulo de giro
var turret_angle = PI/4
var target = null
var turret_range = abs(self.cast_to.y)


#=========Private=============#
var proyectile = "res://scenes/entities/projectiles/RedLaser.tscn"
var can_shoot = false
var enemy = "allies"
var active = true

func _ready():
	var no_collide = WeaponManager.get_parent()
	if no_collide != null:
		self.add_exception(no_collide)
	connect("null_target", WeaponManager, "_on_weapon_null_target")
	_init()

func _init():
	pass

func _physics_process(delta):
	if active:
		if target != null:
			pointing(target.position)
		else:
			emit_signal("null_target", self)
		if self.is_colliding():
			if self.get_collider().is_in_group(enemy):
				_shoot(enemy)

#Desactiva la torreta
func deactivate():
	active = false

#Apuntar hacia un target
func pointing(tg):
	var target = tg- self.global_position
	var angle = Vector2(1,0).rotated(parent.global_rotation).angle_to(target) + PI/2
	var m_rotation = 0
	if turret_angle < PI:
		m_rotation = clamp(lerp_angle(self.rotation,angle,steer_force), -turret_angle,turret_angle)
	else:
		m_rotation = lerp_angle(self.rotation,angle, steer_force)
	self.rotation = m_rotation

#Dispara un simple proyectil
func _shoot(enemy):
	pass

#============================Setter and getters=======================#

func set_target(new_target):
	if new_target != null:
		target = new_target
		
func set_range(rng):
	if rng > 0:
		self.cast_to = Vector2(0,-rng)
		turret_range = rng

func _on_rate_timeout():
	can_shoot = true

