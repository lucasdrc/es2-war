extends Area2D

var adjacent = []
onready var Main: Main = get_node("/root/Main") as Main

func _ready():
	for adj in get_parent().adjacent_names:
		adjacent.append(get_tree().root.find_node(adj, true, false))
	$CollisionPolygon2D/Polygon2D.polygon = $CollisionPolygon2D.polygon
	$CollisionPolygon2D/Adjacent.polygon = $CollisionPolygon2D.polygon

func _process(delta):
	$Text.text = str(get_parent().infantary_count)

func get_territory() -> Territory:
	return get_parent() as Territory

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		match(Main.get_current_state()):
			GameInfo.GAME_STATES.INITIAL, GameInfo.GAME_STATES.PLACING_TERRITORIES:
				if get_parent().player_owner_index == Main.current_player:
					Main.place_infantary(get_parent())
			GameInfo.GAME_STATES.ATTACKING:
				if get_parent().player_owner_index == Main.current_player:
					if Main.get_current_player().selected_territory:
						Main.get_current_player().selected_territory.selected = false
						Main.get_current_player().selected_territory = null
					Main.get_current_player().selected_territory = get_territory() as Territory
					get_territory().selected = true
				else:
					if Main.get_current_player().selected_territory and (get_territory().name in Main.get_current_player().selected_territory.adjacent_names):
						Main.attack_territory(Main.get_current_player().selected_territory, get_territory() as Territory)
