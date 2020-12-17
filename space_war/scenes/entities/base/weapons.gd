extends Node2D

onready var ship = get_node("../..")
var weapon_list = []
var no_weapons = false
var multiple_targets = false

func _ready():
	add_weapons()

#Agregar targets a armas
func add_target(target,weapon):
	weapon.target = target
	weapon.enemy = ship.enemy

func find_targets():
	var targets = []
	#Extraer lista de targets
	if ship.multiple_targets == false:
		targets.append(ship.current_target)
	else:
		for n in (weapon_list.size()):
			if n == 0:
				targets.append(ship.current_target)
			else:
				targets.append(ship.find_enemy())
	#Pasar a las armas los repectivos targets
	for n in weapon_list.size():
		add_target(targets[n], weapon_list[n])



#=======================Init functions===================#
#Agregar las armas disponibles a la lista
func add_weapons():
	for socket in self.get_children():
		for weapon in socket.get_children():
			weapon_list.append(weapon)
	if weapon_list.size() == 0:
		no_weapons = true

