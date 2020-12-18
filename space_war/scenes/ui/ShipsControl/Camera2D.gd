extends Camera2D

var fixed_toggle_point = Vector2(0,0)

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("click0"):
		var ref = get_viewport().get_mouse_position()
		fixed_toggle_point = ref
	if Input.is_action_pressed("click0"):
		slide_map_around()
	$SelectTool.global_position = get_global_mouse_position()
		
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
	# zoom in
			if event.button_index == BUTTON_WHEEL_UP:
				self.zoom -= Vector2(1,1)*0.1
			if event.button_index == BUTTON_WHEEL_DOWN:
				self.zoom += Vector2(1,1)*0.1
func slide_map_around():
	var ref = get_viewport().get_mouse_position()
	self.global_position.x += (ref.x - fixed_toggle_point.x) / 50
	self.global_position.y += (ref.y - fixed_toggle_point.y) / 50
