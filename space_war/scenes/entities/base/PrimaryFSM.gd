extends "res://scenes/entities/base/FSM.gd"

onready var Steering = get_node("../Steering")

 
var courage = 1

#-------------------State machine-------------------#
func _ready():
	add_state("seek")
	add_state("attack")
	add_state("flee")
	call_deferred("set_state",states.seek)
	pass

func _state_logic(delta):
	parent.movement(delta)
	if parent.current_target == null:
		parent.current_target = parent.find_enemy()
		parent.velocity = Vector2(0,0) #<--- Poco realista Agregar amortiguadores
		return null
	state_action(delta)
	
func _get_transition(delta):
	if parent.current_target == null:
		return null
	match state:
		states.seek:
			if parent.radius_attack > parent.position.distance_to(parent.current_target.position):
				return states.attack
		states.attack:
			if parent.radius_attack < parent.position.distance_to(parent.current_target.position):
				return states.seek
			randomize()
			var cowardice = randf()
			if(cowardice > courage):
				return states.flee
		states.flee:
			randomize()
			var cowardice = randf()
			if(cowardice > courage):
				return states.seek
	return null

func _enter_state(new_state, old_state):
	var label = get_node("Panel/Label")
	match new_state:
		states.seek:
			label.text = "State: seek"
		states.attack:
			label.text = "State: attack"
		states.flee:
			label.text = "State: flee"

func _exit_state(old_state, new_state):
	pass

func state_action(delta):
	match state:
		states.seek:
			parent.st_seek()
		states.attack:
			parent.st_attack(delta)
		states.flee:
			parent.st_flee()






