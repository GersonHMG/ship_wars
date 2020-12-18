extends "res://scenes/entities/base/scripts/FSM.gd"

onready var Steering = get_node("../Steering")
#-------------------State machine-------------------#
func _ready():
	add_state("attack")
	add_state("flee")
	call_deferred("set_state",states.attack)

func _state_logic(delta):
	parent.movement(delta)
	if parent.current_target == null:
		parent.find_new_enemy()
	else:
		state_action(delta)

func _get_transition(delta):
	match state:
		states.attack:
			if parent.health < 40:
				return states.flee
				
		states.flee:
			if parent.health >= 80:
				return states.attack

	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.attack:
			pass
		states.flee:
			pass

func _exit_state(old_state, new_state):
	pass


func state_action(delta):
	match state:
		states.attack:
			parent._doAttack(delta)
		states.flee:
			parent._doFlee()


	

	




