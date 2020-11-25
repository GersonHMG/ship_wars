extends Node2D


onready var SelectTool = get_node("SelectTool")
#Este nodo administra las naves

#Instrucciones a la nave
var target

#ESTADOS
var in_enemy = false
var in_area = false
var is_select = false
var current_ship
var current_enemy

func _ready():
	pass

func _physics_process(delta):
	SelectTool.position = get_global_mouse_position()
	if in_area:
		if Input.is_action_just_pressed("click0"):
			if is_select:
				is_select = current_ship.select(false)
			else:
				is_select = current_ship.select(true)
	if is_select and !in_area:
		if Input.is_action_just_pressed("click0"):
			if in_enemy:
				target = current_enemy.position
				current_enemy = null
				print("al enemigo")
			else:
				target = get_global_mouse_position()
			is_select = current_ship.select(false)
			current_ship.pos = target






func _on_SelectTool_body_entered(body):
	if body.is_in_group("allies"):
		in_area = true
		current_ship = body
	if body.is_in_group("enemies") and is_select:
		current_enemy = body
		in_enemy = true
#En el caso que la nave muera hay que cambiar
func _on_SelectTool_body_exited(body):
	if body == current_ship:
		if !is_select:
			current_ship = null
		in_area = false
	if body.is_in_group("enemies") and body == current_enemy:
		in_enemy = false

