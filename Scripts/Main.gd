extends Node2D

class_name Main

onready var current_state = GameInfo.GAME_STATES.INITIAL
onready var player_scene = preload("res://Scenes/Player.tscn")
onready var move_infantary_dialog = preload("res://Scenes/WinnerInfantaryChooser.tscn")
onready var PLAYER_COUNT = GameInfo.PLAYER_COUNT
onready var START_INFANTARY_COUNT = 22
onready var current_player = 0

onready var territories = get_tree().get_nodes_in_group("territories")
onready var shapes = ["triangle", "rectangle", "circle"]
onready var shapeList = []
onready var selected_territory = null

onready var cards_infantary_trade_amount = [4, 6, 8, 10, 12, 15]

onready var players = []

func _ready():
	randomize()
	_start_territories()
	current_player = 0

func _process(delta):
	$Info.text = "Current state: " + str(GameInfo.GAME_STATES.keys()[current_state]) + '\n'
	$Info.text += "Current player: " + get_current_player().color.name + '\n'
	$Info.text += "Infantary remaining: " + str(players[current_player].infantary_count)

func _start_territories():
	for i in range(PLAYER_COUNT):
		var instance = player_scene.instance()
		instance.infantary_count = START_INFANTARY_COUNT
		instance.color = instance.COLORS[i]
		instance.name = "Player " + str(i + 1)
		players.append(instance)
		$Players.add_child(instance)
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
		if i % 14 == 0:
			territories[i].player_card_owner_index = 0
		if i == 15:
			territories[i].player_card_owner_index = 1

func place_infantary(territory):
	if current_state == GameInfo.GAME_STATES.INITIAL:
		if(players[current_player].infantary_count):
			players[current_player].infantary_count -= 1
			territory.infantary_count += 1
		else:
			current_player += 1
			current_player = current_player%PLAYER_COUNT
			var cards_window = get_node("/root/Main/CardsWindow")
			cards_window.player_index = current_player
			cards_window.card_scenes = []
			if(current_player == 0):
				change_game_state(GameInfo.GAME_STATES.PLACING_TERRITORIES)
	elif current_state == GameInfo.GAME_STATES.PLACING_TERRITORIES:
		if(players[current_player].infantary_count):
			players[current_player].infantary_count -= 1
			territory.infantary_count += 1
		else:
			change_game_state(GameInfo.GAME_STATES.ATTACKING)

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
