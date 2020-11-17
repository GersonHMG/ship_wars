extends "res://scenes/entities/base/FSM.gd"

onready var Steering = get_node("../Steering")
onready	var sprite = get_node("../Sprite")
 
func _ready():
	add_state("seek")
	add_state("attack")
	call_deferred("set_state",states.seek)
	pass


func _state_logic(delta):
	parent.test_target()
	parent.movement(delta)
	state_action()
		
	
func _get_transition(delta):
	match state:
		states.seek:
			if parent.radius_attack > parent.position.distance_to(parent.manual_target.position):
				return states.attack
		states.attack:
			if parent.radius_attack < parent.position.distance_to(parent.manual_target.position):
				return states.seek
	return null

func _enter_state(new_state, old_state):
	var label = get_node("Panel/Label")
	match new_state:
		states.seek:
			label.text = "State: seek"
		states.attack:
			label.text = "State: attack"

func _exit_state(old_state, new_state):
	pass

func state_action():
	match state:
		states.seek:
			st_seek()
		states.attack:
			st_attack()

func st_seek():
	sprite.rotation = parent.velocity.angle() + PI/2
	parent.direction = Steering.seek(parent.manual_target.position)
	
func st_attack():
	parent.shoot()
	sprite.rotation = (parent.manual_target.position - parent.position).angle() + PI/2
	parent.direction = Steering.orbiting(parent.manual_target.position, parent.radius_attack - 30)
	



