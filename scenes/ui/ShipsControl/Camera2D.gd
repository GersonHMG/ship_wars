extends Camera2D

var speed = 200
var base_speed = 200
var max_zoom = self.zoom*1.5

func _process(delta):
	#La rapidez varia con el zoom
	speed = base_speed*self.zoom*2
	camera_movement(delta)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
	# zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				self.zoom -= Vector2(1,1)*0.1
	# zoom out
			if event.button_index == BUTTON_WHEEL_DOWN:
				if self.zoom < max_zoom:
					self.zoom += Vector2(1,1)*0.1

func camera_movement(delta):
	var dir = Vector2(0,0)
	if Input.is_action_pressed("ui_right"):
		dir += Vector2(1,0)
	if Input.is_action_pressed("ui_left"):
		dir += Vector2(-1,0)
	if Input.is_action_pressed("ui_up"):
		dir += Vector2(0,-1)
	if Input.is_action_pressed("ui_down"):
		dir += Vector2(0,1)
	dir = dir.normalized()
	self.global_position += dir*speed*delta

