extends Control




#onready var FollowViewport = get_node( "ShipInformation/ViewportContainer2/Viewport2"  )
#onready var GameViewport = get_node("ViewportContainer/Viewport1")
#onready var FollowCamera = get_node("ShipInformation/ViewportContainer2/Viewport2/FollowCamera")
onready var ShipInformation = get_node( "Hud/ShipInformation"  )
onready var AimTargets = get_node( "AimTargets"  )
#onready var PanelNoSignal = get_node("ShipInformation/FollowCameraFrame/PanelNoSignal"  )

var mouse_in_hud = false
var enemy = "allies"
var current_body = null
var ally_body = null



func _ready():
	Engine.time_scale = 0
	#FollowViewport.world_2d = GameViewport.world_2d

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
	if Input.is_action_just_pressed("click0") and !mouse_in_hud:
		
		return true
	return false

#Selecciona la actual nave
func select_ally():
	if current_body != null:
		ally_body = current_body
		ally_body.select()
		#FollowCamera.target = ally_body
		#PanelNoSignal.visible = false


#Deselecciona la nave seleccionada
func unselect_ally():
	if ally_body != null:
		#PanelNoSignal.visible = true
		ShipInformation.clear_bars()
		ally_body.unselect()
		ally_body = null



func update_information():
	ShipInformation.update_information(ally_body)

#================== AIM_TARGETS ===========================================#
var aim_target = {}
#Crea un puntero rojo por cada target que tiene la nave
func create_aim_targets():
	var targets = ally_body.get_all_targets()
	var AIM = preload("res://scenes/entities/effects/aim_target.tscn"  )
	if targets != null:
		for tg in targets:
			if !aim_target.has(tg):
				var pointing = AIM.instance()
				pointing.init(tg)
				AimTargets.add_child(pointing)
				aim_target[tg] = pointing

#Limpia los punteros rojos
func clear_aim_targets():
	for key in aim_target.keys():
		if aim_target.has(key):
			if aim_target[key] != null:
				aim_target[key].queue_free()
	aim_target.clear()

#==================================================================================#


func _on_SelectTool_body_entered(body):
	current_body = body

func _on_SelectTool_body_exited(body):
	if body == current_body:
		current_body = null



#=Botones para escalar el tiempo

func _on_Slow_pressed():
	Engine.time_scale = 0.1


func _on_Continue_pressed():
	Engine.time_scale = 1


func _on_Pause_pressed():
	Engine.time_scale = 0






func _on_TimeControl_mouse_entered():
	mouse_in_hud = true


func _on_TimeControl_mouse_exited():
	mouse_in_hud = false


func _on_Continue_mouse_entered():
	mouse_in_hud = true

func _on_Continue_mouse_exited():
	mouse_in_hud = false
