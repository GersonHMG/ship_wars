extends "res://scenes/entities/base/scripts/FSM.gd"

var offset = 50
onready var Steering = get_node("../Steering")
#-------------------State machine-------------------#
func _ready():
	add_state("close_distance")
	add_state("attack_path")
	add_state("run_away")
	call_deferred("set_state",states.close_distance)

func _state_logic(delta):
	parent.movement(delta)
	#Evita errores
	if parent.current_target == null:
		parent.find_new_enemy()
	else:
		state_action(delta)


func _get_transition(delta):
	match state:
		states.close_distance:
			if parent.get_target_distance() < parent.attack_range - offset:
				return states.attack_path
			if parent.health < parent.max_health*0.2:
				return states.run_away
		states.attack_path:
			if parent.health < parent.max_health*0.2:
				return states.run_away
		states.run_away:
			if parent.health > parent.max_health *0.5:
				return states.close_distance
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.close_distance:
			pass
		states.attack_path:
			pass
		states.run_away:
			pass


func _exit_state(old_state, new_state):
	pass


func state_action(delta):
	match state:
		states.close_distance:
			parent.doCloser()
		states.attack_path:
			parent.doAttack()
			
		states.run_away:
			parent.doRunAway()

		

