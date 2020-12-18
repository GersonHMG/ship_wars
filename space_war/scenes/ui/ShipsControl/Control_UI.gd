extends Control


onready var viewport = get_node("Panel/ViewportContainer/Viewport")
onready var world_camera = get_node("../../Camera2D")


func _ready():
	#viewport.world_2d = world_camera.get_viewport().world_2d 
	pass


