extends Node

#=====Parent variables======#
var ship

#-------Arrival---------------#
var slow_radius = 30
#---------SEEK----------------#
var old_target = Vector2(0,0)
var react = true
var react_time = 0

func _ready():
	ship = get_parent()
	get_react_time()

func get_react_time():
	if ship.react_time >= 0.1:
		react_time = ship.react_time
		$reaction.wait_time = react_time



#----------------------Elemental Steering-------------------------------------#

#Testear puntos: ship.get_parent().get_node("test").position = target

#Va a un punto y cambia la velocidad dependiendo de la curva
func to_point(point):
	#ship.get_parent().get_node("test").position = point
	var thruster_dir = Vector2(1,0).rotated(ship.sprite.rotation - PI/2).normalized()
	#Aceleracion = F/m
	var acceleration = thruster_dir*get_acceleration(point)
	var angle = lerp_angle(ship.sprite.rotation, (point - ship.global_position).angle() + PI/2, ship.turn_speed)
	ship.sprite.rotation = angle
	return acceleration

#Con la fuerza de los cohetes otorga el resultado convertido en aceleracion
func get_acceleration(point):
	var target_dir = (point - ship.global_position).normalized()
	var thruster_dir = Vector2(1,0).rotated(ship.sprite.rotation - PI/2).normalized()
	var cambio = target_dir.dot(thruster_dir)
	var acceleration = Vector2(0,0)
	if cambio > 0:
		acceleration = cambio*ship.max_thruster_force/ship.mass
	return acceleration




#========================Common Steerings======================================#

#-------------------------Trayectories-----------------------------------------#

#Recorre puntos en forma sinusoidal
func s_trayectory(target, lambda, A):	#(target, width , height)
	var pos = ship.position
	var angle =  target.angle_to_point(ship.position)
	var distance = target.distance_to(ship.position)
	pos.x += cos(angle + sin(distance/lambda))*A 
	pos.y += sin(angle + sin(distance/lambda))*A 
	return to_point(pos)

#-------------------------Dynamic targets--------------------------------------#


#Perseguir a un target
func seek(target):
	if react_time < 0.1:
		return to_point(target)
	if react:
		old_target = target
		react = false
		$reaction.start()
		return to_point(target)
	else:
		var point = ship.position + Vector2(old_target - ship.position).normalized()*20
		var acceleration = to_point(point)
		return acceleration

func _on_reaction_timeout():
	react = true

func run_away(target):
	var vector_dir = (ship.global_position - target).normalized()
	var point = ship.global_position + vector_dir*30
	var acceleration = to_point(point)
	return acceleration

#CAMBIAAR!!
#Ir a un punto y parar
#func arrival(target):
#	var distance = ship.position.distance_to(target)
#	if distance < slow_radius:
#		ship.max_speed = ship.max_speed*(distance/slow_radius)
#	else:
#		ship.max_speed = 300
#	return to_point(target)

func arrival(point):
	var factor = 1/(ship.global_position.distance_to(point) + 1)
	var r_acc = (ship.velocity*-1)*factor
	var angle = lerp_angle(ship.sprite.rotation, (point - ship.global_position).angle() + PI/2, ship.turn_speed)
	ship.sprite.rotation = angle
	return r_acc


#Entrega puntos de una circunferencia dependiendo de la ubicacion.
func orbiting(point, r):
	var offset = 0.2
	var angle = (ship.position - point).angle_to(Vector2(1,0)) + PI/2
	angle += offset
	if angle < 0:
		angle = 2*PI + angle
	angle = fmod(angle,2*PI)
	#angle = truncated_angle(angle) #probar con stepify()
	var circle_point = Vector2(point.x + sin(angle)*r, point.y + cos(angle)*r)
	return to_point(circle_point)


var rng = RandomNumberGenerator.new()
func wander():
	var head = Vector2(1,0).rotated(ship.sprite.rotation - PI/2).normalized()
	var circle_center = ship.global_position + head*80
	var radius = 50
	rng.randomize()
	var rand_x = rng.randf_range(-1, 1)
	var rand_y = rng.randf_range(-1, 1)
	
	var rand_vector = Vector2(rand_x,rand_y)*radius
	var direction = circle_center + rand_vector
	#ship.get_parent().get_node("test").global_position = direction
	return to_point(direction)
	
var wander_angle = 0
func run_away_wander(target):
	var head = (ship.global_position - target).normalized()
	var circle_center = ship.global_position + head*80
	var radius = 50
	rng.randomize()
	var angle_change = 0.5
	wander_angle += rng.randf()*angle_change - angle_change*0.5
	var vec = Vector2(1,0).rotated(wander_angle)
	var rand_vector = vec.normalized()*radius
	var direction = circle_center + rand_vector
	#ship.get_parent().get_node("test").global_position = direction
	return to_point(direction)
	


#------------------------------------------------------------------------------------------#
#------------------------Utility functions------------------------------------------------#
#Trunca al angulo mas proximo
func truncated_angle(angle):
	var p = 30
	var new_angle = rad2deg(angle)
	if fmod(new_angle,p) != 0:
		new_angle = new_angle-fmod(new_angle,p)+p
		return deg2rad(new_angle)
	return angle

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference


