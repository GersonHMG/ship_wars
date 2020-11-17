extends Node

var ship
var new_point = true
var current_point = Vector2(0,0)
var n = RandomNumberGenerator.new()

var slow_radius = 30

func _ready():
	ship = get_parent()

#----------------------Elemental Steering-------------------------------------#
#Va a un punto
func to_point(target):
	var d_velocity = ((target - ship.global_position).normalized())*ship.speed
	var steering = (d_velocity - ship.velocity)*ship.steer_force
	return steering
#Corre de un punto
func run_away(target):
	var d_velocity = ((ship.global_position - target).normalized())*ship.speed
	var steering = (d_velocity - ship.velocity)*ship.steer_force
	return steering

#----------------------Common Steerings-------------------------------------------#
#Orbita circular al rededor del target
func orbiting(point, r):
	var distance = (ship.position - point)
	var angle = distance.angle_to(Vector2(1,0))
	angle = truncated_angle(angle)
	var circle_point = Vector2(point.x + sin(angle)*r, point.y + cos(angle)*r)
	var desired = to_point(circle_point)
	return desired

#Correr a un target
func seek(target):
	return to_point(target)

#Ir a un punto y parar
func arrival(target):
	var distance = ship.position.distance_to(target)
	var d_velocity = (target-ship.position).normalized()*ship.speed
	if distance < slow_radius:
		d_velocity = d_velocity.normalized()*ship.speed*(distance/slow_radius)
		return d_velocity - ship.velocity
	return to_point(target)

func avoid(point,center):
	var avoidance_point = (point - center)
	ship.test.position = avoidance_point
	var final_point = to_point(avoidance_point)
	return final_point


func wander():
	#circle center
	var circle_pos = ship.position + ship.velocity.normalized()*10
	n.randomize()
	var angle = n.randf_range(0,2*PI)
	var target = circle_pos + 2*Vector2(5,0).rotated(angle)
	if !(pow((ship.position.y-300),2)+pow(ship.position.x-500,2) <= pow(300,2)):
	#if !(0 < ship.position.y and ship.position.y <600) or !(0 < ship.position.x and ship.position.x <1000):
		var center = Vector2(500,300)
		return orbiting(center, 300)
	return to_point(target)
	
	
#Mejorar esto!!!
func free_route():
	if new_point:
		new_point = false
		n.randomize()
		var random_y = n.randi_range(-200,200) + 280
		var random_x = n.randi_range(-200,200) + 500
		current_point = Vector2(random_x,random_y)
		return to_point(Vector2(random_x,random_y))
	return to_point(current_point)

#------------------------Auxiliar functions-----------------------------------#
func truncated_angle(angle):
	var p = 30
	var new_angle = rad2deg(angle)
	if fmod(new_angle,p) != 0:
		new_angle = new_angle-fmod(new_angle,p)+p
		return deg2rad(new_angle)
	return angle

#Punto aleatorio cada tantos segundos
func _on_random_route_timeout():
	new_point = true
