extends Node2D

onready var ship = get_parent()
var enemy = ""
#Diccionario {weapon: target, weapon1 : target2 ...}
var weapon_target = {}
var multiple_targets = false

func _ready():
	multiple_targets = ship.multiple_targets
	enemy = ship.enemy
	init_weapons()


#=======================Init functions===================#

#Inicia el nodo
#De aca comienza todo
func init_weapons():
	weapon_target = {}
	var weapons = get_weapons()
	var unique_target = find_enemy()
	#Relaciona un arma con un target
	for weapon in weapons:
		if multiple_targets:
			var target = find_enemy()
			weapon_target[weapon] = target
			target_to_weapon(target,weapon)
		else:
			weapon_target[weapon] = unique_target
			target_to_weapon(unique_target,weapon)
	#Le otorga a la nave el valor
	#del rango promedio de las armas
	if weapons.size() > 0:
		var weaponRange = average_weapon_range(weapons)
		ship.set_weapon_range(weaponRange)

func change_close_enemy():
	var close_enemy = find_close_enemy()
	for weapon in weapon_target.keys():
		weapon_target[weapon] = close_enemy

#=========================================================#
#Retorna el rango promedio de las armas en la lista
func average_weapon_range(weapon_list):
	var sum = 0
	for weapon in weapon_list:
		sum += weapon.turret_range
	if weapon_list.size() > 0:
		return sum/weapon_list.size()
	return 0

#Agregar target a una arma
func target_to_weapon(target,weapon):
	weapon.target = target
	weapon.enemy = enemy

#Retorna un enemigo al azar
func find_enemy():
	var ships = get_tree().get_nodes_in_group(enemy)
	if ships.size() > 0:
		randomize()
		var n = randi()%(ships.size())
		return ships[n]
	return null

#Busca el enemigo mas cercano
func find_close_enemy():
	var ships = get_tree().get_nodes_in_group(enemy)
	var r_enemy = null
	if ships.size() > 0:
		for enemigo in ships:
			if r_enemy == null:
				r_enemy = enemigo
			else:
				if (enemigo.global_position).distance_to(ship.global_position) < r_enemy.global_position.distance_to(ship.global_position):
					r_enemy = enemigo
		return r_enemy
	return null


#===================Getters and setters===================#
#Retorna todas las armas disponibles en un array
func get_weapons():
	var weapons = []
	for socket in self.get_children():
		if socket.name[0] == "s":
			for weapon in socket.get_children():
				weapons.append(weapon)
	return weapons

#Otorga un target al azar en la lista de targets
func get_target():
	if weapon_target.size() == 0:
		return null
	var rand = randi()%(weapon_target.size())
	var key = weapon_target.keys()[rand]
	if weapon_target[key] == null:
		update_dictionary(key)
	return weapon_target[key]
	
func get_all_targets():
	var r_targets = []
	for weapon in weapon_target:
		r_targets.append(weapon_target[weapon])
	return r_targets

func update_dictionary(weapon):
	if weapon_target[weapon] == null:
		weapon_target[weapon] = find_enemy()

#Funcion que elimine los target null
func _on_weapon_null_target(weapon):
	var target = get_target()
	if target == null:
		weapon.deactivate()
	else:
		weapon.set_target(target)


	

