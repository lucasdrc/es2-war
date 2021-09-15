extends Node2D

class_name Main

onready var current_state = GameInfo.GAME_STATES.INITIAL
onready var player_scene = preload("res://Scenes/Player.tscn")
onready var move_infantary_dialog = preload("res://Scenes/WinnerInfantaryChooser.tscn")
onready var log_dialog_scene = preload("res://Scenes/LogDialog.tscn")
onready var PLAYER_COUNT = GameInfo.PLAYER_COUNT
onready var START_INFANTARY_COUNT = 22
onready var current_player = 0
onready var receives_territory_card = false
onready var territories = get_tree().get_nodes_in_group("territories")
onready var shapes = ["triangle", "rectangle", "circle"]
onready var shapeList = []
onready var selected_territory = null
onready var players = []
var random_number_gen = RandomNumberGenerator.new()

func _ready():
	Log.add_log_msg("New game started.")
	Log.add_log_msg("Main Scene loaded.")
	random_number_gen.randomize()
	_instantiating_players()	
	_start_territories()
	current_player = 0
	Log.add_log_msg("New current player: {0} ({1}).".format([players[current_player].name,
															 players[current_player].color.name]))

func _process(delta):
	$Info.text = "CURRENT PLAYER: " + get_current_player().color.name + '\n'
	$Info.text += "GAME TURN PHASE: " + str(GameInfo.GAME_STATES.keys()[current_state]) + '\n'
	$Info.text += "INFANTARY REMAINING: " + str(players[current_player].infantary_count)
	_update_game_state()
	_update_NextPhaseButton()
	if(_current_player_is_ia()): _simulate_ia_player()

func _current_player_movement_done():
	if(current_state == GameInfo.GAME_STATES.INITIAL or
	   current_state == GameInfo.GAME_STATES.PLACING_TERRITORIES):
		return players[current_player].infantary_count == 0

func _current_player_is_ia():
	return players[current_player].is_ia()

func update_current_player():
	if (receives_territory_card):
		reveive_territory_card()
		receives_territory_card = false
	current_player = (current_player + 1)%PLAYER_COUNT
	Log.add_log_msg("Current player updated: {0} ({1}).".format([players[current_player].name,
															 players[current_player].color.name]))
	instantiate_player_cards_window()

func reveive_territory_card():
	var counter = 0
	var exit = false
	while counter < len(territories) and not exit:
		if territories[counter].player_card_owner_index == null:
			territories[counter].player_card_owner_index = current_player
			exit = true
		counter += 1

func instantiate_player_cards_window():
	var cards_window = get_node("/root/Main/CardsWindow")
	cards_window.player_index = current_player
	cards_window.card_scenes = []
	
func _update_game_state():
	if(current_state == GameInfo.GAME_STATES.INITIAL and _current_player_movement_done()):
		update_current_player()
		if(current_player == 0): change_game_state(GameInfo.GAME_STATES.PLACING_TERRITORIES)
	elif(current_state == GameInfo.GAME_STATES.PLACING_TERRITORIES and _current_player_movement_done()):
		change_game_state(GameInfo.GAME_STATES.ATTACKING)
	elif(current_state == GameInfo.GAME_STATES.ATTACKING and _current_player_movement_done()):
		change_game_state(GameInfo.GAME_STATES.MOVING_TERRITORIES)

func _update_NextPhaseButton(): 
	if(current_state == GameInfo.GAME_STATES.ATTACKING):
		$NextPhaseButton.visible = true
		$NextPhaseButton.text = "DONE ATTACKING"
	elif(current_state == GameInfo.GAME_STATES.MOVING_TERRITORIES):
		$NextPhaseButton.text = "FINISH TURN"
	elif(current_state == GameInfo.GAME_STATES.TRADING_TERRITORY_CARDS):
		$NextPhaseButton.text = "DONE TRADING CARDS"
	else: $NextPhaseButton.visible = false

func _on_NextPhaseButton_pressed():
	var cards_window = get_node("/root/Main/CardsWindow")
	cards_window.init_cards(current_player)
	if (current_state == GameInfo.GAME_STATES.TRADING_TERRITORY_CARDS and not cards_window.has_to_trade_cards()):
		change_game_state(GameInfo.GAME_STATES.PLACING_TERRITORIES)
	if(current_state == GameInfo.GAME_STATES.ATTACKING):
		change_game_state(GameInfo.GAME_STATES.MOVING_TERRITORIES)
	elif(current_state == GameInfo.GAME_STATES.MOVING_TERRITORIES):
		update_current_player()
		cards_window.init_cards(current_player)
		if (cards_window.can_trade_cards()):
			change_game_state(GameInfo.GAME_STATES.TRADING_TERRITORY_CARDS)
		else:
			change_game_state(GameInfo.GAME_STATES.PLACING_TERRITORIES)

func _simulate_ia_player():
	OS.delay_msec(400)
	if(current_state == GameInfo.GAME_STATES.INITIAL): place_territories_ia_player()
	elif(current_state == GameInfo.GAME_STATES.PLACING_TERRITORIES):
		var dialog = players[current_player].get_node_or_null("DialogBox")
		if(dialog):
			if(dialog.time >= 0.2): dialog.get_node("Button").emit_signal("pressed")
		else: place_territories_ia_player()
	elif(current_state == GameInfo.GAME_STATES.ATTACKING): attack_ia_player()
	elif(current_state == GameInfo.GAME_STATES.MOVING_TERRITORIES): move_territories_ia_player()

func place_territories_ia_player():
	var territories = players[current_player].get_territories_conquered_by_player()
	var i = random_number_gen.randi_range(0, territories.size() - 1)
	place_infantary(territories[i])

func continue_attacking(): return random_number_gen.randi_range(1, 10) > 2

func get_territory_by_name(name):
	var all_territories = get_tree().get_nodes_in_group("territories")
	for territory in all_territories: if(territory.name == name): return territory

func attack_ia_player():
	var dialog = get_node_or_null("Popup")
	if(dialog):
		var possibilities = []
		var button_1 = get_node("Popup/MarginContainer/VBoxContainer/HBoxContainer/Button1Infantary")
		var button_2 = get_node("Popup/MarginContainer/VBoxContainer/HBoxContainer/Button2Infantary")
		var button_3 = get_node("Popup/MarginContainer/VBoxContainer/HBoxContainer/Button3Infantary")
		if(not button_1.disabled): possibilities.push_back(button_1)
		if(not button_2.disabled): possibilities.push_back(button_2)
		if(not button_3.disabled): possibilities.push_back(button_3)
		var i = random_number_gen.randi_range(0, possibilities.size() - 1)
		possibilities[i].emit_signal("pressed")
	else:
		var attacking_territories = players[current_player].get_possible_attacking_territories()
		if(attacking_territories.size() > 0 and continue_attacking()):
			var i = random_number_gen.randi_range(0, attacking_territories.size() - 1)
			var defending_territories = []
			for name in attacking_territories[i].adjacent_names:
				if(get_territory_by_name(name).player_owner_index != current_player):
					defending_territories.push_back(name)
			var j = random_number_gen.randi_range(0, defending_territories.size() - 1)
			var defending_territory = get_territory_by_name(defending_territories[j])
			attack_territory(attacking_territories[i], defending_territory)
		else:
			get_node("NextPhaseButton").emit_signal("pressed")

func continue_moving_territories(): return random_number_gen.randi_range(1, 3) > 1

func move_territories_ia_player():
	OS.delay_msec(5000)
	var moving_territories = players[current_player].get_possible_moving_territories()
	if(moving_territories.size() > 0 and continue_moving_territories()):	
		var i = random_number_gen.randi_range(0, moving_territories.size() - 1)
		var receiver_territories = []
		for name in moving_territories[i].adjacent_names:
			if(get_territory_by_name(name).player_owner_index == current_player):
				receiver_territories.push_back(name)
		var j = random_number_gen.randi_range(0, receiver_territories.size() - 1)
		var receiver_territory = get_territory_by_name(receiver_territories[j])
		move_territory(moving_territories[i], receiver_territory)
	else:
		get_node("NextPhaseButton").emit_signal("pressed")

func _instantiating_players():
	for i in range(PLAYER_COUNT):
		var new_player = player_scene.instance()
		new_player.infantary_count = START_INFANTARY_COUNT
		new_player.color = new_player.COLORS[i]
		new_player.name = "Player " + str(i + 1)
		new_player.state = GameInfo.active_players[i]
		players.append(new_player)
		$Players.add_child(new_player)
	Log.add_log_msg("Players instantiated.")

func _start_territories():
	territories.shuffle()
	for i in range(shapes.size()):
		for j in range(territories.size() / shapes.size()):
			shapeList.append(shapes[i])
	shapeList.shuffle()
	for i in range(territories.size()):
		current_player = i%PLAYER_COUNT
		place_infantary(territories[i])
		territories[i].player_owner_index = current_player
		territories[i].shape = shapeList[i]
	Log.add_log_msg("Territories assigned to players.")

func place_infantary(territory):
	if (players[current_player].infantary_count):
		players[current_player].infantary_count -= 1
		territory.infantary_count += 1
		Log.add_log_msg("+1 infantary added to %s." % territory.name)

func move_territory(origin_territory: Territory, destination_territory: Territory):
	if(origin_territory.infantary_count == 1):
		return
	origin_territory.infantary_count -= 1
	destination_territory.infantary_count += 1

func attack_territory(attacking_territory: Territory, defending_territory: Territory):
	if(attacking_territory.infantary_count == 1):
		return
	var attacking_player_dice = randi()%6+1
	var defending_player_dice = randi()%6+1
	if attacking_player_dice > defending_player_dice:
		defending_territory.infantary_count -= 1
		if(not defending_territory.infantary_count):
			defending_territory.player_owner_index = current_player
			Log.add_log_msg("{0} ({1}) conquered {2}.".format([players[current_player].name,
															   players[current_player].color.name,
															   defending_territory.name]))
			var dialog = move_infantary_dialog.instance()
			dialog.attacker_territory = attacking_territory
			dialog.defeated_territory = defending_territory
			add_child(dialog)
			receives_territory_card = true
	else:
		attacking_territory.infantary_count -= 1
	print("Attack: ", attacking_player_dice, " -- Defense: ", defending_player_dice)

func move_infantary_to_defeated_territory(attacker: Territory, defeated: Territory, amount: int):
	if(attacker.infantary_count + 1 > amount):
		attacker.infantary_count -= amount
		defeated.infantary_count += amount
		Log.add_log_msg("+%d infatary(ies) moved to %s." % [amount, defeated.name])

func change_game_state(new_state):
	current_state = new_state
	Log.add_log_msg("Game state updated: %s" % GameInfo.GAME_STATES.keys()[current_state])
	if new_state == GameInfo.GAME_STATES.PLACING_TERRITORIES:
		(players[current_player] as Player).receive_infantary()
		
func get_current_player() -> Player:
	return players[current_player]

func get_player(index) -> Player:
	return players[index] as Player

func get_current_state():
	return current_state

func _on_LogButton_pressed():
	if(get_node_or_null("LogDialog") == null):
		var log_dialog = log_dialog_scene.instance()
		add_child(log_dialog)
