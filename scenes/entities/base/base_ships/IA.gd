extends Node
#Este script devuelve el vector de movimiento

onready var Steering = get_node("../Steering")
onready var Ship = get_parent()
var attack = true


func _ready():
	pass

func run_ia(delta):
	var movement = Vector2(0,0)
	#Aca se toman las decisiones respecto a los estados
	var target = Ship.manual_target
	if attack and target != null:
		movement = simple_attack(target)
	return movement
	

var is_close = false
func simple_attack(target):
	var point = (Ship.position - target.position).clamped(100)
	var transform = target.get_transform()
	point = transform.xform(point)
	var vector = Vector2(0,0)
	if is_close == true:
		vector = Steering.orbiting(Vector2(point.x,point.y), 200)
	else:
		vector = Steering.arrival(point)
		if Ship.position.distance_to(point) < 120:
			is_close = true

	return vector
