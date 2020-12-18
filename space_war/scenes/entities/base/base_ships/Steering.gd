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
	var angle = lerp_angle(ship.sprite.rotation, (point - ship.position).angle() + PI/2, ship.turn_speed)
	ship.sprite.rotation = angle
	return acceleration
	
func get_acceleration(point):
	var target_dir = (point - ship.global_position).normalized()
	var thruster_dir = Vector2(1,0).rotated(ship.sprite.rotation - PI/2).normalized()
	var cambio = target_dir.dot(thruster_dir)
	var acceleration = Vector2(0,0)
	if cambio > 0:
		acceleration = cambio*ship.max_thruster_force/ship.mass
	return acceleration
	


#Corre de un punto



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

func run_away(target):
	var vector_dir = (ship.global_position - target).normalized()
	var point = ship.global_position + vector_dir*30
	var acceleration = to_point(point)
	return acceleration

#CAMBIAAR!!
#Ir a un punto y parar
func arrival(target):
	var distance = ship.position.distance_to(target)
	if distance < slow_radius:
		ship.max_speed = ship.max_speed*(distance/slow_radius)
	else:
		ship.max_speed = 300
	return to_point(target)


#-------------------------Static targets------------------------------------#


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

#MEEEEEEEEJORAR!!!
func star(point, t):
	var A = 20
	var R = 5
	var r = 3
	var d = 5
	var x = A*((R-r)*cos(t)+d*cos((R-r)*t/r)) + point.x
	var y = A*((R-r)*sin(t)-d*sin((R-r)*t/r)) + point.y
	#Buscar punto mas cercano
	var final_point = Vector2(x,y)
	return to_point(final_point)	





func _on_reaction_timeout():
	react = true






#------------------------------------------------------------------------------------------#
#------------------------Auxiliar functions------------------------------------------------#
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


