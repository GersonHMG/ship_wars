extends KinematicBody2D

#-------------Ship setup----------------#
export var max_speed = 200
var speed = 50
#var side_speed = max_speed*0.4
var turret_speed = 10
var steer_force = 0.08
var radius_attack = 150
var health = 100
#-------------Parametros de combate---------------------#
export var enemy = "allies"
export var attack_path = "orbiting" #orbiting, random, arrival
var current_target
var clockwise = -1
var t = 0
#----------Variables fisicas-------------#
var velocity = Vector2(0,0)
var direction = Vector2(0,0)
#---------------States-------------------#
var can_shoot = false
#---------------Node---------------------#
onready var steering = get_node("Steering")
onready var sprite = get_node("Sprite")
#----------------DEBUG-------------------#
var test_steering = false
export var manual_control = false


func _ready():
	if test_steering or manual_control:
		get_node("PrimaryFSM").set_physics_process(false)
	current_target = find_enemy()
	if enemy == "allies":
		clockwise = 1
	else:
		clockwise = -1


func _physics_process(delta):
	if test_steering:
		test_steering(delta)
	if manual_control:
		manual_control()
	
	movement(delta)
	#SISTEMA DE APUNTAR AL ENEMIGO
	if current_target != null:
		pointing(delta, $weapon)


#=====================Movement================================#
func movement(delta):
	velocity += direction
	velocity = velocity.clamped(max_speed)
	velocity = move_and_slide(velocity)
#=============================================================#


#=======================Combat=================================#
func damage(dmg):
	health -= dmg
	if health <= 0:
		self.queue_free()
	
#Dispara un simple proyectil
func shoot():
	if can_shoot:
		can_shoot = false
		var projectile = load("res://scenes/entities/projectiles/RedLaser.tscn").instance()
		var dir = Vector2(1,0).rotated($weapon.global_rotation + PI/2)
		projectile.setup(dir, speed, $weapon/gun_pos.global_position, enemy)
		get_parent().add_child(projectile)	#!!!CAMBIAR ESTO
		

#Retorna un enemigo al azar
func find_enemy():
	var ships = get_tree().get_nodes_in_group(enemy)
	if ships.size() > 0:
		randomize()
		var n = randi()%(ships.size())
		return ships[n]
	return null
	
#Mueve la torreta hacia un lugar especifico
func pointing(delta, weapon):
	var target_dir = (current_target.global_position - self.global_position).normalized()
	var turret_dir = Vector2(1,0).rotated(weapon.global_rotation)
	var ship_vector = Vector2(1,0).rotated(sprite.global_rotation + PI)
	if turret_dir.angle_to(ship_vector) < PI/4 and turret_dir.angle_to(ship_vector) > -PI/4:
		$weapon.global_rotation = target_dir.angle() - PI/2
	else:
		$weapon.global_rotation = ship_vector.angle()
#=============================================================#

#================States-functions=============================#

func st_seek():
	if speed < max_speed:
		speed += 1
	sprite.rotation = velocity.angle() + PI/2
	direction = steering.seek(current_target.global_position)
	

func st_attack(delta):
	if get_node("weapon").is_colliding():
		if get_node("weapon").get_collider().is_in_group(enemy):
			shoot()
	if attack_path == "orbiting":
		direction = steering.orbiting(current_target.global_position, radius_attack - 30)
	if attack_path == "random":
		t += clockwise*(speed/50)*delta
		direction = steering.lissajous(current_target.global_position,t)
	sprite.rotation = velocity.angle() + PI/2

func st_flee():
	direction = steering.run_away(current_target.global_position)

#===============================================================#

#========================Utility===============================#
func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight
	
	
func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
#================================================================#



#=======================Debug========================================#


func manual_control():
	var target = get_global_mouse_position()
	direction = get_node("Steering").to_point(target)
	$Sprite.rotation = velocity.angle() + PI/2
	if Input.is_action_pressed("ui_accept"):
		shoot()


func test_steering(delta):
	if current_target != null:
		direction = get_node("Steering").s_trayectory(current_target.position, 100)
		$Sprite.rotation = velocity.angle() + PI/2


#====================================================================#


#================================Signals============================#

func _on_rate_timeout():
	can_shoot = true


func select(flag):
	if flag == true:
		$Sprite.modulate = Color(0,255,255,255)
		return true
	$Sprite.modulate = Color(1,1,1,1)
	return false
