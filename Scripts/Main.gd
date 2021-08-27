extends Node2D

class_name Main

onready var current_state = GameInfo.GAME_STATES.INITIAL
onready var player_scene = preload("res://Scenes/Player.tscn")
onready var move_infantary_dialog = preload("res://Scenes/WinnerInfantaryChooser.tscn")
onready var PLAYER_COUNT = GameInfo.PLAYER_COUNT
onready var START_INFANTARY_COUNT = 22
onready var current_player = 0
onready var territories = get_tree().get_nodes_in_group("territories")
onready var selected_territory = null
onready var players = []

func _ready():
	randomize()
	_instantiating_players()
	_start_territories()
	current_player = 0

func _process(delta):
	$Info.text = "Current state: " + str(GameInfo.GAME_STATES.keys()[current_state]) + '\n'
	$Info.text += "Current player: " + get_current_player().color.name + '\n'
	$Info.text += "Infantary remaining: " + str(players[current_player].infantary_count)
	$Tips.text = "Current player: " + get_current_player().color.name + '\n'
	$Tips.text += "Game round fase: " + str(GameInfo.GAME_STATES.keys()[current_state])
	_game_control()

func _current_player_movement_done():
	if(current_state == GameInfo.GAME_STATES.INITIAL or
	   current_state == GameInfo.GAME_STATES.PLACING_TERRITORIES):
		return players[current_player].infantary_count == 0

func update_current_player():
	current_player = (current_player + 1)%PLAYER_COUNT
	
func _game_control():
	if(current_state == GameInfo.GAME_STATES.INITIAL and _current_player_movement_done()):
		update_current_player()
		if(current_player == 0): change_game_state(GameInfo.GAME_STATES.PLACING_TERRITORIES)
	elif(current_state == GameInfo.GAME_STATES.PLACING_TERRITORIES and _current_player_movement_done()):
		change_game_state(GameInfo.GAME_STATES.ATTACKING)

func _instantiating_players():
	for i in range(PLAYER_COUNT):
		var new_player = player_scene.instance()
		new_player.infantary_count = START_INFANTARY_COUNT
		new_player.color = new_player.COLORS[i]
		new_player.name = "Player " + str(i + 1)
		players.append(new_player)
		$Players.add_child(new_player)

func _start_territories():
	territories.shuffle()
	for i in range(territories.size()):
		current_player = i%PLAYER_COUNT
		place_infantary(territories[i])
		territories[i].player_owner_index = current_player

func place_infantary(territory):
	if(players[current_player].infantary_count):
		players[current_player].infantary_count -= 1
		territory.infantary_count += 1

func attack_territory(attacking_territory: Territory, defending_territory: Territory):
	if(attacking_territory.infantary_count == 1):
		return
	var attacking_player_dice = randi()%6+1
	var defending_player_dice = randi()%6+1
	if attacking_player_dice > defending_player_dice:
		defending_territory.infantary_count -= 1
		if(not defending_territory.infantary_count):
			defending_territory.player_owner_index = current_player
			var dialog = move_infantary_dialog.instance()
			dialog.attacker_territory = attacking_territory
			dialog.defeated_territory = defending_territory
			add_child(dialog)
	else:
		attacking_territory.infantary_count -= 1
	print("Attack: ", attacking_player_dice, " -- Defense: ", defending_player_dice)

func move_infantary_to_defeated_territory(attacker: Territory, defeated: Territory, amount: int):
	if(attacker.infantary_count + 1 > amount):
		attacker.infantary_count -= amount
		defeated.infantary_count += amount

func change_game_state(new_state):
	current_state = new_state
	if new_state == GameInfo.GAME_STATES.PLACING_TERRITORIES:
		(players[current_player] as Player).receive_infantary()
	elif new_state == GameInfo.GAME_STATES.ATTACKING:
		pass
		
func get_current_player() -> Player:
	return players[current_player]

func get_player(index) -> Player:
	return players[index] as Player

func get_current_state():
	return current_state

func _on_NextPhaseButton_pressed():
	if(current_state == GameInfo.GAME_STATES.ATTACKING):
		change_game_state(GameInfo.GAME_STATES.MOVING_TERRITORIES)
	elif(current_state == GameInfo.GAME_STATES.MOVING_TERRITORIES):
		current_player += 1
		current_player = current_player%PLAYER_COUNT
		change_game_state(GameInfo.GAME_STATES.PLACING_TERRITORIES)
