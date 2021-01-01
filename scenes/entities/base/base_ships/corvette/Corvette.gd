extends "res://scenes/entities/base/base_ships/base_ship.gd"

export var attack_path = "orbital"

func _ready():
	#===Movement===#
	max_thruster_force = 20
	max_speed = 100
	turn_speed = 0.02
	#===Health=====#
	set_health(500)
	#===Pilot===#
	react_time = 0.1
	#===Ship====#
	size = 100

func doCloser():
	acceleration = steering.seek(current_target.global_position)

func doAttack():
	if attack_path == "orbital":
		var radius = attack_range*0.60
		acceleration = steering.orbiting(current_target.global_position, radius)
func doRunAway():
	acceleration = steering.run_away_wander(current_target.global_position)

func _manual_control(delta):
	movement(delta)
	acceleration = steering.seek(get_global_mouse_position())


func _on_LaserTurret_null_target(weapon):
	pass # Replace with function body.


func _on_MissileTurret_null_target(weapon):
	pass # Replace with function body.
