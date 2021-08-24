extends Node2D

enum GAME_STATES {INITIAL, PLACING_TERRITORIES, ATTACKING, MOVING_TERRITORIES}
onready var current_state = GAME_STATES.INITIAL
onready var player_scene = preload("res://Scenes/Player.tscn")
onready var PLAYER_COUNT = GameInfo.PLAYER_COUNT
onready var START_INFANTARY_COUNT = 35
onready var current_player = 0

onready var territories = get_tree().get_nodes_in_group("territories")
onready var shapes = ["triangle", "rectangle", "circle"]
onready var shapeList = []
onready var selected_territory = null

onready var players = []

func _ready():
	randomize()
	_start_territories()
	current_player = 0

func _process(delta):
	$Info.text = "Current state: " + str(GAME_STATES.keys()[current_state]) + '\n'
	$Info.text += "Current player: " + get_current_player().color.name + '\n'
	$Info.text += "Infantary remaining: " + str(players[current_player].infantary_count)

func _start_territories():
	for i in range(PLAYER_COUNT):
		var instance = player_scene.instance()
		instance.infantary_count = 35
		instance.color = instance.COLORS[i]
		instance.name = "Player " + str(i + 1)
		players.append(instance)
		add_child(instance)
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

func place_infantary(territory):
	if current_state == GAME_STATES.INITIAL:
		if(players[current_player].infantary_count):
			players[current_player].infantary_count -= 1
			territory.infantary_count += 1
		else:
			current_player += 1
			current_player = current_player%PLAYER_COUNT

func get_current_player():
	return players[current_player]

func get_player(index):
	return players[index]

