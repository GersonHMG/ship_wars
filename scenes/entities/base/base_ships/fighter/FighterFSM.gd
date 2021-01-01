extends "res://scenes/entities/base/scripts/FSM.gd"

var offset = 50
onready var Steering = get_node("../Steering")
#-------------------State machine-------------------#
func _ready():
	add_state("close_distance")
	add_state("attack_path")
	add_state("attack_maneuver")
	add_state("run_away")
	add_state("run_away_maneuver")
	add_state("back_attack")
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
			if parent.get_target_distance() < parent.attack_range:
				return states.attack_path
			if parent.health < parent.max_health*0.2:
				return states.run_away
		states.attack_path:
			if parent.health < parent.max_health*0.2:
				return states.run_away
			if prob_distance_event(0.4, 300, delta):
				return states.attack_maneuver
			#Si la nave esta de espalda
			
			elif parent.target_is_back():
				return states.back_attack
		states.run_away:
			if parent.health > parent.max_health *0.5:
				return states.close_distance
				
			if prob_distance_event(0.5, 300, delta):
				return states.run_away_maneuver
		states.back_attack:
			#Si la nave no esta de espalda
			if !parent.target_is_back():
				return states.attack_path
		states.attack_maneuver:
			if maneuver_end(0.6, delta):
				return states.attack_path
			
		
		states.run_away_maneuver:
			if maneuver_end(3,delta):
				return states.run_away
			

	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.close_distance:
			pass
		states.attack_path:
			pass
		states.run_away:
			pass
		states.attack_maneuver:
			pass


func _exit_state(old_state, new_state):
	match old_state:
		states.attack_path:
			bufferDisplacement = 0
		states.run_away:
			bufferDisplacement = 0
		states.run_away_maneuver:
			bufferTime = 0
			parent.bufferPoint = Vector2(0,0)


func state_action(delta):
	match state:
		states.close_distance:
			parent.doCloser()
		states.attack_path:
			parent.doAttack()
		
		states.attack_maneuver:
			parent.doAttackManeuver()
			
		states.run_away:
			parent.doRunAway()
		
		states.run_away_maneuver:
			parent.doRunAwayManeuver()
		states.back_attack:
			parent.doArrivalAttack()
		
var bufferTime = 0
func maneuver_end(wait, delta):
	bufferTime += delta
	if bufferTime > wait:
		bufferTime = 0
		return true
	return false

var bufferDisplacement = 0
func prob_distance_event(probability, displacement, delta):
	bufferDisplacement += delta*parent.velocity.length()
	if bufferDisplacement > displacement:
		randomize()
		var rand = randf()
		bufferDisplacement = 0
		if rand > probability:
			return true
		return false
