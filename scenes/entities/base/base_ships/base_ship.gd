extends KinematicBody2D
#------------Pilot setup----------------#
#inhuman < 0.1
export var react_time = 0.1
#-------------Ship setup----------------#
var max_speed = 300
var max_thruster_force = 30
var max_health = 100
var mass = 1
var turn_speed = 0.2
var energy = 100
var multiple_targets = false
var weapon_range = 0
#-------------Parametros de combate---------------------#
export var enemy = ""
#=====================PRIVADOS==========================#
var current_target = null	#Target al que sigue
var attack_range = 0
var health = max_health
var size = 0
var head = Vector2(0,0)
#----------Variables fisicas-------------#
var velocity = Vector2(0,0)
var acceleration = Vector2(0,0)
#---------------Node---------------------#
onready var steering = get_node("Steering")
onready var sprite = get_node("WeaponManager")
onready var weapons = get_node("WeaponManager")
#----------------DEBUG-------------------#
export var god_mode = false
export var manual_control = false


signal removed

func _ready():
	if manual_control:
		get_node("FSM").set_physics_process(false)
	


func _physics_process(delta):
	head = Vector2(1,0).rotated(sprite.rotation - PI/2).normalized()
	#----------Debug-------------#
	if manual_control:
		_manual_control(delta)
		

#=====================Movement================================#
func movement(delta):
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
			destroy()

func destroy():
	emit_signal("removed", self)
	self.queue_free()

func find_new_enemy():
	current_target = weapons.change_close_enemy()
	current_target = weapons.get_target()
	
	if current_target == null:
		#ACA SE DEBERIA DESACTIVAR
		pass
	else:
		attack_range = current_target.size + weapon_range
		if attack_range < 0:
			attack_range = 0
	

#==========================Utility================================#

#REPASAR METODO!!
#entrega la distancia de la nave a un objeto
func get_target_distance():
	if current_target != null:
		var distance = self.global_position.distance_to(current_target.global_position)
		return distance
	return 999

#Retorna todos los targets sin repeticiones
func get_all_targets():
	return weapons.get_all_targets()


func target_is_back():
	if current_target != null:
		var ship_tg = (current_target.global_position - self.global_position).normalized()
		if current_target.head.dot(ship_tg) > 0.4:
				return true
	return false


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

func set_health(hp):
	max_health = hp
	health = hp

func set_weapon_range(val):
	weapon_range = val


#=======================Debug========================================#


func _manual_control(delta):
	pass





