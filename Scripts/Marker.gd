extends Area2D

var adjacent = []
onready var Main = get_node("/root/Main")

func _ready():
	for adj in get_parent().adjacent_names:
		adjacent.append(get_tree().root.find_node(adj, true, false))
	$CollisionPolygon2D/Polygon2D.polygon = $CollisionPolygon2D.polygon
	$CollisionPolygon2D/Adjacent.polygon = $CollisionPolygon2D.polygon

func _process(delta):
	#
	$CollisionPolygon2D/Polygon2D.color.a = 0.8
	$Text.text = str(get_parent().infantary_count)

func _on_Area2D_mouse_entered():
	pass

func _on_Area2D_mouse_exited():
	pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		if get_parent().player_owner_index != Main.current_player:
			return
		else:
			Main.place_infantary(get_parent())
