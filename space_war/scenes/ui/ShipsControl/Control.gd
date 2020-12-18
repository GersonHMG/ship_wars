extends Control

var enemy = "allies"
var current_body = null
var ally_body = null

onready var FollowViewport = get_node( "ShipInformation/ViewportContainer2/Viewport2"  )
onready var GameViewport = get_node("ViewportContainer/Viewport1")
onready var FollowCamera = get_node("ShipInformation/ViewportContainer2/Viewport2/FollowCamera")
onready var ShipInformation = get_node("ShipInformation")


func _ready():
	FollowViewport.world_2d = GameViewport.world_2d

#True si hace click en un aliado, false si no lo hace
func click_ally():
	if Input.is_action_just_pressed("click0") and current_body != null:
		if current_body.is_in_group("allies"):
			return true
	return false

#True si hace click en un enemigo, false si no lo hace
func click_enemy():
	if Input.is_action_just_pressed("click0") and current_body != null:
		if current_body.is_in_group("enemies"):
			return true
	return false

#True si se hace click, false si no se hace click
func click_nothing():
	if Input.is_action_just_pressed("click0"):
		return true
	return false

#Selecciona la actual nave
func select_ally():
	if current_body != null:
		ally_body = current_body
		ally_body.select()
		FollowCamera.target = ally_body


#Deselecciona la nave seleccionada
func unselect_ally():
	if ally_body != null:
		ally_body.unselect()
		ally_body = null

func update_information():
	ShipInformation.update_information(ally_body)


func _on_SelectTool_body_entered(body):
	current_body = body

func _on_SelectTool_body_exited(body):
	if body == current_body:
		current_body = null
