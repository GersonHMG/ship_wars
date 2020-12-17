extends KinematicBody2D
#------------Pilot setup----------------#
#inhuman < 0.1
export var react_time = 0.1
#-------------Ship setup----------------#
var max_speed = 50
var max_thruster_force = 0
var health = 100
var mass = 1
var steer_force = 0.08
var turn_speed = 0.15
var multiple_targets = false
#-------------Parametros de combate---------------------#
export var enemy = "allies"
export var attack_path = "orbiting" #orbiting, random, arrival
var current_target = null
#----------Variables fisicas-------------#
var velocity = Vector2(0,0)
var acceleration = Vector2(0,0)
#---------------Node---------------------#
onready var steering = get_node("Steering")
onready var sprite = get_node("Sprite")
onready var weapons = get_node("Sprite/weapons")
#----------------DEBUG-------------------#
export var god_mode = false
export var manual_control = false

#Constantes CAMBIAR ESTO!!
var attack_range = 80

func _ready():
	if manual_control:
		get_node("PrimaryFSM").set_physics_process(false)


func _physics_process(delta):
	#----------Debug-------------#
	if manual_control:
		manual_control(delta)
		movement(delta)
		
		

	#if current_target == null:
	#	current_target = find_enemy()
	#	if current_target != null:
	#		weapons.new_target(current_target,enemy)



#=====================Movement================================#
func movement(delta):
	velocity += acceleration
	velocity = velocity.clamped(max_speed)
	velocity = move_and_slide(velocity)
	acceleration = Vector2(0,0)

#=============================================================#


#=======================Combat=================================#


func damage(dmg):
	if !god_mode:
		health -= dmg
		if health <= 0:
			self.queue_free()


#Retorna un enemigo al azar
func find_enemy():
	var ships = get_tree().get_nodes_in_group(enemy)
	if ships.size() > 0:
		randomize()
		var n = randi()%(ships.size())
		return ships[n]
	return null

#=============================================================#


#================States-functions=============================#


func doAttack(delta):
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


func doFlee():
	acceleration = steering.run_away(current_target.global_position)
	sprite.rotation = velocity.angle() + PI/2
	health += 1




#====================================================================#


#=======================Debug========================================#


func manual_control(delta):
	var target_pos = get_global_mouse_position()
	if Input.is_action_pressed("ui_accept"):
		var angle = (target_pos - self.position).angle() + PI/2
		var m_rotation = lerp_angle(sprite.rotation,angle , 0.2)
		sprite.rotation = m_rotation
		turn_to_target()
		pass
	else:
		
#		if can_maneuver:
#			turn_to_target()
#		else:
		acceleration = steering.orbiting(target_pos,100)
		

#========================Maneuvers==========================#
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


#================================Signals=============================#








