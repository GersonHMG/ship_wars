extends MarginContainer


var map_center = Vector2(250,250)
export var zoom = 3

onready var Grid = get_node("Grid")
onready var EnemyMarker = get_node("Grid/EnemyMarker"  )
onready var AllyMarker = get_node( "Grid/AllyMarker" )

onready var icons = {"enemies": EnemyMarker, "allies": AllyMarker}

var grid_scale
var markers = {}

func _ready():
	#AllyMarker.position = Grid.rect_size / 2
	grid_scale = Grid.rect_size / (get_viewport_rect().size * zoom)
	var groups = ["enemies","allies"]
	for team in groups:
		var map_objects = get_tree().get_nodes_in_group(team)
		for item in map_objects:
			item.connect("removed", self, "_on_object_removed")
			var new_marker = icons[team].duplicate()
			Grid.add_child(new_marker)
			new_marker.show()
			markers[item] = new_marker

func _process(delta):
	for item in markers:
		var obj_pos = (item.position - map_center) * grid_scale + Grid.rect_size / 2
		markers[item].position = obj_pos
		obj_pos.x = clamp(obj_pos.x, 0, Grid.rect_size.x)
		obj_pos.y = clamp(obj_pos.y, 0, Grid.rect_size.y)

func _on_object_removed(object):
	print("remover objeto")
	if object in markers:
		markers[object].queue_free()
		markers.erase(object)
