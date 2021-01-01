extends "res://scenes/entities/base/turrets/Turret.gd"





func _shoot(enemy):
	if can_shoot:
		can_shoot = false
		var bullet = load(proyectile).instance()
		var dir = Vector2(1,0).rotated(self.global_rotation - PI/2)
		bullet.setup(dir, $gun_pos.global_position, enemy)
		bullet_spawn.add_child(bullet)	#!!!CAMBIAR ESTO
