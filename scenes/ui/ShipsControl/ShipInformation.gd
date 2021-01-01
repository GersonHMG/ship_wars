extends Control


onready var HealthBar = get_node("HudFrame/ShipStatus/HealthBar")
onready var EnergyBar = get_node("HudFrame/ShipStatus/EnergyBar")

func _ready():
	pass

func update_information(ship):
	if ship:
		var information = ship.get_information()
		HealthBar.set_progress(information["health"])
		EnergyBar.set_progress(information["energy"])

func clear_bars():
	HealthBar.set_progress(0)
	EnergyBar.set_progress(0)
