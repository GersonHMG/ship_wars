extends Node2D

onready var ship = get_parent().get_parent()
var enemy = ""

var weapon_target = {}
var multiple_targets = false

func _ready():
	multiple_targets = ship.multiple_targets
	enemy = ship.enemy
	init_weapons()

	
#=======================Init functions===================#

#Inicia el nodo
func init_weapons():
	#Relaciona un arma a un target
	var weapons = get_weapons()
	weapon_target = {}
	var unique_target = find_enemy()
	for weapon in weapons:
		if multiple_targets:
			var target = find_enemy()
			weapon_target[weapon] = target
			target_to_weapon(target,weapon)
		else:
			weapon_target[weapon] = unique_target
			target_to_weapon(unique_target,weapon)

#=========================================================#

#Agregar target a una arma
func target_to_weapon(target,weapon):
	weapon.target = target
	weapon.enemy = enemy

#Encuentra enemigos en los nodos
func find_enemy():
	var ships = get_tree().get_nodes_in_group(enemy)
	if ships.size() > 0:
		randomize()
		var n = randi()%(ships.size())
		return ships[n]
	return null

#===================Getters and setters===================#
#Retorna todas las armas disponibles en un array
func get_weapons():
	var weapons = []
	for socket in self.get_children():
		for weapon in socket.get_children():
			weapons.append(weapon)
	return weapons

func update_dictionary(weapon):
	if weapon_target[weapon] == null:
		weapon_target[weapon] = find_enemy()

#Otorga un target al azar en la lista de targets
func get_target():
	if weapon_target.size() == 0:
		return null
	var rand = randi()%(weapon_target.size())
	var key = weapon_target.keys()[rand]
	if weapon_target[key] == null:
		update_dictionary(key)
	return weapon_target[key]

#Funcion que elimine los target null
func _on_weapon_null_target(weapon):
	var target = get_target()
	if target == null:
		weapon.deactivate()
	else:
		weapon.set_target(target)

