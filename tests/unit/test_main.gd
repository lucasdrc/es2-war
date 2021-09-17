extends "res://addons/gut/test.gd"

var _Main = load("res://Scenes/Main.tscn")
var _main = null
var _player = null

func before_each():
	GameInfo.active_players = [1,1,1,1,1,1]
	_main = _Main.instance()
	_player = double("res://Scenes/Player.tscn").instance()
	_player.color = {"name": "empty", "color": Color.white}
	stub(_player, 'get_territories_conquered_by_player').to_return([1,2,3])
	_main.current_player = 0
	_main.shapes = ["triangle", "rectangle", "circle"]
	_main.shapeList = []
	_main.players = [_player, _player, _player, _player, _player, _player]

func test_player_ended_placing_territories():
	_main.PLAYER_COUNT = 6
	_main.current_state = 0
	_player.infantary_count = 0
	_main._current_player_movement_done()
	assert_true(_main._current_player_movement_done(), "ERRO")

func test_change_to_next_player():
	_main.current_player = 0
	_main.PLAYER_COUNT = 6
	_main.current_state = 0
	_main.update_current_player()
	assert_eq(_main.current_player, 1, "ERRO")
	for i in range(5):
		_main.update_current_player()
	assert_eq(_main.current_player, 0, "ERRO")

func test_change_game_state_from_initial_to_placing():
	_player = double("res://Scenes/Player.tscn").instance()
	_main.current_player = 5
	_main.PLAYER_COUNT = 6
	_main.current_state = 0
	_player.infantary_count = 0
	_main._update_game_state()
	assert_eq(_main.current_state, 1, "ERRO")

func test_change_game_state_from_placing_to_attacking():
	_main.current_player = 0
	_main.PLAYER_COUNT = 6
	_main.current_state = 1
	_player.infantary_count = 0
	_main._update_game_state()
	assert_eq(_main.current_state, 2, "ERRO")

func test_initial_players_instantiation():
	_main.player_scene = load("res://Scenes/Player.tscn")
	_main.PLAYER_COUNT = 4
	_main.players = []
	_main._instantiating_players()
	assert_eq(_main.players.size(), 4, "ERRO")

func test_territory_initialization():
	_main.territories = []
	_main.current_player = 0
	_main.PLAYER_COUNT = 6
	for i in range(42):
		var new_ter = double("res://Scripts/Territory.gd").new()
		_main.territories.append(new_ter)
	_main._start_territories()
	assert_eq(_main.territories.size(), 42, "ERRO")

func test_attack_territory_without_defeating():
	var attack_ter = double("res://Scripts/Territory.gd").new()
	attack_ter.player_owner_index = 0
	attack_ter.infantary_count = 10
	var defend_ter = double("res://Scripts/Territory.gd").new()
	defend_ter.player_owner_index = 1
	defend_ter.infantary_count = 10
	_main.attack_territory(attack_ter, defend_ter, 6, 1)
	assert_eq(defend_ter.infantary_count, 9, "ERRO")
	assert_eq(attack_ter.infantary_count, 10, "ERRO")
	assert_eq(attack_ter.player_owner_index, 0, "ERRO")
	assert_eq(defend_ter.player_owner_index, 1, "ERRO")

func test_attack_territory_defeating():
	_main.move_infantary_dialog = load("res://Scenes/WinnerInfantaryChooser.tscn")
	_main.current_player = 0
	var attack_ter = double("res://Scripts/Territory.gd").new()
	attack_ter.player_owner_index = 0
	attack_ter.infantary_count = 10
	var defend_ter = double("res://Scripts/Territory.gd").new()
	defend_ter.player_owner_index = 1
	defend_ter.infantary_count = 1
	_main.attack_territory(attack_ter, defend_ter, 6, 1)
	assert_eq(defend_ter.infantary_count, 0, "ERRO")
	assert_eq(attack_ter.infantary_count, 10, "ERRO")
	assert_eq(attack_ter.player_owner_index, 0, "ERRO")
	assert_eq(defend_ter.player_owner_index, 0, "ERRO")

func test_failed_attack():
	var attack_ter = double("res://Scripts/Territory.gd").new()
	attack_ter.player_owner_index = 0
	attack_ter.infantary_count = 10
	var defend_ter = double("res://Scripts/Territory.gd").new()
	defend_ter.player_owner_index = 1
	defend_ter.infantary_count = 10
	_main.attack_territory(attack_ter, defend_ter, 1, 6)
	assert_eq(defend_ter.infantary_count, 10, "ERRO")
	assert_eq(attack_ter.infantary_count, 9, "ERRO")
	assert_eq(attack_ter.player_owner_index, 0, "ERRO")
	assert_eq(defend_ter.player_owner_index, 1, "ERRO")

func test_move_infantary_to_defeated_territory():
	var attack_ter = double("res://Scripts/Territory.gd").new()
	attack_ter.player_owner_index = 0
	attack_ter.infantary_count = 10
	var defend_ter = double("res://Scripts/Territory.gd").new()
	defend_ter.player_owner_index = 0
	defend_ter.infantary_count = 0
	_main.move_infantary_to_defeated_territory(attack_ter, defend_ter, 3)
	assert_eq(defend_ter.infantary_count, 3, "ERRO")
	assert_eq(attack_ter.infantary_count, 7, "ERRO")
	assert_eq(attack_ter.player_owner_index, 0, "ERRO")
	assert_eq(defend_ter.player_owner_index, 0, "ERRO")
