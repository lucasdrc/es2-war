extends "res://addons/gut/test.gd"

var _Marker = load("res://Scripts/Marker.gd")
var _marker = null

func before_each():
	_marker = _Marker.new()

func test_place_infantary_owned_territory():
	var new_ter = double("res://Scripts/Territory.gd").new()
	var new_player = double("res://Scripts/Player.gd").new()
	var new_main = load("res://Scripts/Main.gd").new()
	new_ter.infantary_count = 2
	new_ter.player_owner_index = 0
	new_player.infantary_count = 10
	new_main.current_player = 0
	new_main.players = [new_player]
	_marker._Main = new_main
	_marker._place_infantary(new_ter)
	assert_eq(new_ter.infantary_count, 3, "ERRO")
	assert_eq(new_player.infantary_count, 9, "ERRO")

func test_place_infantary_unowned_territory():
	var new_ter = double("res://Scripts/Territory.gd").new()
	var new_player = double("res://Scripts/Player.gd").new()
	var new_main = load("res://Scripts/Main.gd").new()
	new_ter.infantary_count = 2
	new_ter.player_owner_index = 1
	new_player.infantary_count = 10
	new_main.current_player = 0
	new_main.players = [new_player]
	_marker._Main = new_main
	_marker._place_infantary(new_ter)
	assert_eq(new_ter.infantary_count, 2, "ERRO")
	assert_eq(new_player.infantary_count, 10, "ERRO")
