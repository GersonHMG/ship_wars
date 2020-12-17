extends Panel

onready var ship = get_node("../..")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_tss_value_changed(value):
	$tss/count.text = String(value)
	ship.max_speed = value

func _on_sf_value_changed(value):
	$sf/count.text = String(value)
	ship.max_thruster_force = value
