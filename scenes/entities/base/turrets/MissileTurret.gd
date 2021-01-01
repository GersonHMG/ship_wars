extends "res://scenes/entities/base/turrets/Turret.gd"

func _init():
	self.set_range(300)
	$rate.wait_time = 1
	turret_angle = PI
	proyectile = "res://scenes/entities/projectiles/Missile.tscn"
	

func _shoot(enemy):
	if can_shoot:
		can_shoot = false
		var missile = load(proyectile).instance()
		var dir = Vector2(1,0).rotated(self.global_rotation - PI/2)
		missile.setup(target, $gun_pos.global_position, enemy)
		bullet_spawn.add_child(missile)
		
