extends Area2D

var adjacent = []
var selected = false

func _ready():
	for adj in get_parent().adjacent_names:
		adjacent.append(get_tree().root.find_node(adj, true, false))
	$CollisionPolygon2D/Polygon2D.polygon = $CollisionPolygon2D.polygon
	$CollisionPolygon2D/Adjacent.polygon = $CollisionPolygon2D.polygon
	$CollisionPolygon2D/Polygon2D.color.a = 0
	$CollisionPolygon2D/Adjacent.color.a = 0

func _process(delta):
	if(selected):
		$CollisionPolygon2D/Polygon2D.color.a = 0.2
		for adj in adjacent:
			adj.get_node("Area2D/CollisionPolygon2D/Adjacent").color.a = 0.4


func _on_Area2D_mouse_entered():
	
	selected = true

func _on_Area2D_mouse_exited():
	selected = false
	$CollisionPolygon2D/Polygon2D.color.a = 0
	for adj in adjacent:
		adj.get_node("Area2D/CollisionPolygon2D/Adjacent").color.a = 0


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		$Text.text = str(int($Text.text) + 1)
