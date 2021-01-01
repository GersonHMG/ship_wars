extends "res://scenes/entities/base/base_ships/base_ship.gd"


export var attack_path = "orbital"

func _ready():
	
	size = 75
	max_thruster_force = 30
	max_speed = 200
	turn_speed = 0.08
	react_time = 0.1
	set_health(100)
	
#Lista de acciones
func doCloser():
	acceleration = steering.seek(current_target.global_position)

func doAttack():
	if attack_path == "orbital":
		var radius = (attack_range)*0.75
		acceleration = steering.orbiting(current_target.global_position, radius)

func doArrivalAttack():
	var distance = get_target_distance()
	if distance > weapon_range*0.8:
		acceleration = steering.seek(current_target.global_position)
	else:
		var point = self.global_position +  (current_target.global_position - self.global_position ).normalized()*30
		acceleration = steering.arrival(point)
		pass
		#aca debe desacelerar
	

func doAttackManeuver():
	var target_pos = current_target.global_position
	var angle = (target_pos - self.position).angle() + PI/2
	var m_rotation = lerp_angle(sprite.rotation,angle , self.turn_speed*0.5)
	sprite.rotation = m_rotation

func doRunAway():
	acceleration = steering.run_away_wander(current_target.global_position)
	

var bufferPoint = Vector2(0,0)
func doRunAwayManeuver():
	if bufferPoint == Vector2(0,0):
		var head = Vector2(1,0).rotated(self.sprite.rotation - PI/2).normalized()
		bufferPoint = self.global_position + head*500
	acceleration = steering.s_trayectory(bufferPoint, 100, 50)
	
func _manual_control(delta):
	movement(delta)
	if Input.is_action_pressed("ui_accept"):
		acceleration = steering.arrival(get_global_mouse_position())
	else:
		acceleration = steering.seek(get_global_mouse_position())
	

