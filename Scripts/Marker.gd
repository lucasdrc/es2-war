extends Area2D

var adjacent = []
onready var _Main = get_node("/root/Main")

func _ready():
	for adj in get_territory().adjacent_names:
		adjacent.append(get_tree().root.find_node(adj, true, false))
	$CollisionPolygon2D/Polygon2D.polygon = $CollisionPolygon2D.polygon
	$CollisionPolygon2D/Adjacent.polygon = $CollisionPolygon2D.polygon

func _process(delta):
	$Text.text = str(get_territory().infantary_count)

func get_territory() -> Territory:
	return get_parent() as Territory

func _place_infantary(territory: Territory):
	if territory.player_owner_index == _Main.current_player:
		_Main.place_infantary(territory)

func _select_or_attack(territory: Territory):
	if territory.player_owner_index == _Main.current_player:
		if _Main.get_current_player().selected_territory:
			_Main.get_current_player().selected_territory.selected = false
			_Main.get_current_player().selected_territory = null
		_Main.get_current_player().selected_territory = territory
		territory.selected = true
	else:
		if _Main.get_current_player().selected_territory and (territory.name in _Main.get_current_player().selected_territory.adjacent_names):
			var attacking_player_dice = randi()%6+1
			var defending_player_dice = randi()%6+1
			_Main.attack_territory(_Main.get_current_player().selected_territory, territory, attacking_player_dice, defending_player_dice)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if _Main.get_current_player().is_ia(): return
	if event.is_action_pressed("click"):
		match(_Main.get_current_state()):
			GameInfo.GAME_STATES.INITIAL, GameInfo.GAME_STATES.PLACING_TERRITORIES:
				_place_infantary(get_territory())
			GameInfo.GAME_STATES.ATTACKING:
				if get_parent().player_owner_index == _Main.current_player:
					if _Main.get_current_player().selected_territory:
						_Main.get_current_player().selected_territory.selected = false
						_Main.get_current_player().selected_territory = null
					_Main.get_current_player().selected_territory = get_territory() as Territory
					get_territory().selected = true
				else:
					if _Main.get_current_player().selected_territory and (get_territory().name in _Main.get_current_player().selected_territory.adjacent_names):
						var attacking_player_dice = randi()%6+1
						var defending_player_dice = randi()%6+1
						_Main.attack_territory(_Main.get_current_player().selected_territory, get_territory() as Territory, attacking_player_dice, defending_player_dice)
			GameInfo.GAME_STATES.MOVING_TERRITORIES:
				print(_Main.get_current_player().selected_origin_territory)
				print(_Main.get_current_player().selected_destination_territory)
				if get_parent().player_owner_index == _Main.current_player:
					if _Main.get_current_player().selected_origin_territory == null and _Main.get_current_player().selected_destination_territory == null:
						_Main.get_current_player().selected_origin_territory = get_territory() as Territory
						get_territory().selected = true
					elif _Main.get_current_player().selected_origin_territory != null and _Main.get_current_player().selected_destination_territory == null:
						if _Main.get_current_player().selected_origin_territory == (get_territory() as Territory):
							_Main.get_current_player().selected_origin_territory.selected = false
							_Main.get_current_player().selected_origin_territory = null
							print("Descelecionei origem")
						else:
							if (get_territory().name in _Main.get_current_player().selected_origin_territory.adjacent_names) and get_parent().player_owner_index == Main.current_player:
								_Main.get_current_player().selected_destination_territory = get_territory() as Territory
								_Main.move_territory(_Main.get_current_player().selected_origin_territory,_Main.get_current_player().selected_destination_territory)
								_Main.get_current_player().selected_destination_territory = null
						
