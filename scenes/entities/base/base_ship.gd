extends KinematicBody2D

#-------------Ship config----------------#
var max_speed = 300
export var speed = 200
var steer_force = 0.1

#----------Variables fisicas-------------#
var velocity = Vector2(0,0)
var acceleration = Vector2(0,0)
var direction = Vector2(0,0)

#---------------States-------------------#
var can_shoot = false
var radius_attack = 200

#----------------DEBUG-------------------#
export(NodePath) var node_path
var manual_target

func _ready():
	manual_target = get_node(node_path)
	
func test_target():
	manual_target = get_node(node_path)

func _physics_process(delta):
	#$Sprite.rotation = velocity.angle() + PI/2
	pass

func movement(delta):
	acceleration = direction	
	velocity += acceleration
	velocity = velocity.clamped(max_speed)
	velocity = move_and_slide(velocity)

func shoot():
	if can_shoot:
		print("Disparar")
		can_shoot = false
		var projectile = load("res://scenes/entities/projectiles/RedLaser.tscn").instance()
		projectile.speed = speed + projectile.speed
		projectile.direction = Vector2(1,0).rotated(direction.angle())
		projectile.rotation = direction.angle()
		get_node("../../bullets").add_child(projectile)
		projectile.global_position = get_node("Sprite/weapon/Position2D").global_position


func select(flag):
	if flag == true:
		$Sprite.modulate = Color(0,255,255,255)
		return true
	$Sprite.modulate = Color(1,1,1,1)
	return false

func _on_Timer_timeout():
	can_shoot = true
