extends "res://scenes/entities/base/scripts/FSM.gd"


func _ready():
	add_state("wait_click")
	add_state("select_ally")
	call_deferred("set_state",states.wait_click)

func _state_logic(delta):
	state_action(delta)
	pass
	
func _get_transition(delta):
	match state:
		states.wait_click:
			if parent.click_ally():
				return states.select_ally
		states.select_ally:
			if parent.click_ally():
				return states.select_ally
			if parent.ally_body == null:
				parent.clear_aim_targets()
				return states.wait_click
			elif parent.click_enemy():
				print("cambiar target")
				if parent.ally_body.has_method("set_target"):
					print("se cambio satisfactoriamente")
					parent.ally_body.set_target(parent.current_body)
				return states.wait_click
			elif parent.click_nothing():
				return states.wait_click
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.wait_click:
			print("wait_click")
		states.select_ally:
			print("select_ally")
			parent.select_ally()
			parent.create_aim_targets()
		

	
func _exit_state(old_state, new_state):
	match old_state:
		states.select_ally:
			parent.clear_aim_targets()
			parent.unselect_ally()
	pass
	
func state_action(delta):
	match state:
		states.wait_click:
			pass
		states.select_ally:
			parent.update_information()
	pass
