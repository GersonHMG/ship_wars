extends KinematicBody2D
#------------Pilot setup----------------#
#inhuman < 0.1
export var react_time = 0.1
#-------------Ship setup----------------#
var max_speed = 300
var max_thruster_force = 0
var health = 100
var mass = 1
var turn_speed = 0.15
var energy = 100
#POSILIBLE CAMBIO
var multiple_targets = false
#-------------Parametros de combate---------------------#
export var enemy = "allies"

#POSIBLE CAMBIO
export var attack_path = "orbiting" #orbiting, random, arrival

#=====================PRIVADOS==========================#
var current_target = null	#Target al que sigue
var ship_size = 0 #<-------- USAR 
#----------Variables fisicas-------------#
var velocity = Vector2(0,0)
var acceleration = Vector2(0,0)
#---------------Node---------------------#
onready var steering = get_node("Steering")
onready var sprite = get_node("Sprite")
onready var weapons = get_node("Sprite/WeaponManager")
#----------------DEBUG-------------------#
export var god_mode = false
export var manual_control = false

#Constantes CAMBIAR ESTO!!
var attack_range = 80

func _ready():
	if manual_control:
		get_node("StateMovement").set_physics_process(false)

func _physics_process(delta):
	#----------Debug-------------#
	if manual_control:
		manual_control(delta)
		movement(delta)

#=====================Movement================================#
func movement(delta):
	energy -= 0.01
	velocity += acceleration
	velocity = velocity.clamped(max_speed)
	velocity = move_and_slide(velocity)
	acceleration = Vector2(0,0)

#=============================================================#


#=======================Combat=================================#

#Maneja el daño recibido
func damage(dmg):
	if !god_mode:
		health -= dmg
		if health <= 0:
			self.queue_free()

func find_new_enemy():
	current_target = weapons.get_target()
	if current_target == null:
		deactivate()
	

func deactivate():
	get_node("StateMovement").set_physics_process(false)

#=============================================================#


#================States-functions=============================#


func _doAttack(delta):
	#Disparar
	#Ejecutar movimientos
	var target_pos = current_target.global_position
	#ALERTA BUG!
	if self.position.distance_to(target_pos) >= attack_range+200:
			#Acercarce al jugador
			acceleration = steering.seek(target_pos)
			#sprite.rotation = velocity.angle() + PI/2
	else:
		if attack_path == "orbital":
			
			#sprite.rotation = velocity.angle() + PI/2
			if can_maneuver:
				turn_to_target()
			else:
				acceleration = steering.orbiting(target_pos, 100)
			
		elif attack_path == "arrival":
			var attack_pos = target_pos + Vector2(self.position - target_pos).normalized()*attack_range
			acceleration = steering.arrival(attack_pos) 


func _doFlee():
	acceleration = steering.run_away(current_target.global_position)
	sprite.rotation = velocity.angle() + PI/2
	health += 0.01




#====================================================================#



		

#========================Maneuvers==================================#
var can_maneuver = false
func turn_to_target():
	if current_target != null:
		var target_pos = current_target.global_position
		var angle = (target_pos - self.position).angle() + PI/2
		var m_rotation = lerp_angle(sprite.rotation,angle , 0.2)
		sprite.rotation = m_rotation

func _on_maneuver_timeout():
	randomize()
	var time = randf() / (5 - 3) + 3
	if can_maneuver:
		can_maneuver = false
		$Steering/maneuver.wait_time = time
		$Steering/maneuver.start()
	else:
		can_maneuver = true
		$Steering/maneuver.wait_time = 0.5
		$Steering/maneuver.start()

#====================================================================#


#========================== UI =======================================#

func select():
	sprite.self_modulate = Color(255,255,255,255)

func unselect():
	sprite.self_modulate = Color(1,1,1,1)
	

#====================================================================#

#===================Setters and Getters===============================#


#Retorna toda la informacion para UI
func get_information():
	var information = {}
	information["health"] = health
	information["energy"] = energy
	return information

func set_target(new_target):
	if new_target != null:
		current_target = new_target


#=======================Debug========================================#


func manual_control(delta):
	var target_pos = get_global_mouse_position()
	acceleration = steering.seek(target_pos)





