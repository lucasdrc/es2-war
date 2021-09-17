extends Node2D

class_name MainTestAttackTerritory

onready var current_state = GameInfo.GAME_STATES.PLACING_TERRITORIES
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

func _ready():
	Log.add_log_msg("New game started.")
	Log.add_log_msg("Main Scene loaded.")
	randomize()
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

func _current_player_movement_done():
	if(current_state == GameInfo.GAME_STATES.INITIAL or
	   current_state == GameInfo.GAME_STATES.PLACING_TERRITORIES):
		return players[current_player].infantary_count == 0

func update_current_player():
	if (receives_territory_card):
		reveive_territory_card()
		receives_territory_card = false
	current_player = (current_player + 1)%PLAYER_COUNT
	Log.add_log_msg("Current player updated: {0} ({1}).".format([players[current_player].name,
															 players[current_player].color.name]))
	if(players[current_player].get_territories_conquered_by_player().size() == 0):
		update_current_player()     
	else:         
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
	if cards_window:
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

func _instantiating_players():
	for i in range(PLAYER_COUNT):
		var new_player = player_scene.instance()
		new_player.infantary_count = START_INFANTARY_COUNT
		new_player.color = new_player.COLORS[i]
		new_player.name = "Player " + str(i + 1)
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
		territory.infantary_count += 3
		
		Log.add_log_msg("+1 infantary added to %s." % territory.name)

func move_territory(origin_territory: Territory, destination_territory: Territory):
	if(origin_territory.infantary_count == 1):
		return
	origin_territory.infantary_count -= 1
	destination_territory.infantary_count += 1

func attack_territory(attacking_territory: Territory, defending_territory: Territory, attacking_player_dice: int, defending_player_dice: int):
	if(attacking_territory.infantary_count <= 1):
		return
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
			if(checkWinner()):
				GameInfo.WINNER = players[current_player].color.displayName
				GameInfo.WINNER_COLOR = players[current_player].color.color
				get_tree().change_scene("res://Scenes/EndScreen.tscn")
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
		
func checkWinner():
	if get_tree() == null:
		return
	for territory in get_tree().get_nodes_in_group("territories"):
		if(territory.player_owner_index != current_player):
			return false
	return true
