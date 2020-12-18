extends Panel

onready var health = get_node("HealthLabel/Health")
onready var energy = get_node("EnergyLabel/Energy")

func _ready():
	pass

func update_information(ship):
	if ship:
		var information = ship.get_information()
		health.text = str(information["health"])
		energy.text = str(information["energy"])


