extends "res://scenes/entities/base/FSM.gd"

onready var Steering = get_node("../Steering")



#-------------------State machine-------------------#
func _ready():
	add_state("attack")
	add_state("flee")
	call_deferred("set_state",states.attack)

func _state_logic(delta):
	parent.movement(delta)
	if parent.current_target == null:
		var target = parent.find_enemy()
		parent.current_target = target
		if target == null:
			parent.velocity = Vector2(0,0)
		else:
			parent.weapons.find_targets()
	state_action(delta)
	
func _get_transition(delta):
	if parent.current_target == null:
		return null
	match state:
		states.attack:
			if parent.health < 40:
				return states.flee
		states.flee:
			if parent.health >= 80:
				return states.attack
	return null

func _enter_state(new_state, old_state):
	var label = get_node("Panel/sLabel")
	match new_state:
		states.attack:
			label.text = "State: attack"
		states.flee:
			label.text = "State: flee"

func _exit_state(old_state, new_state):
	pass

func state_action(delta):
	match state:
		states.attack:
			parent.doAttack(delta)
		states.flee:
			parent.doFlee()







