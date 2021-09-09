extends Node

class_name PlayerSelectionScreen

var players = [
	GameInfo.PLAYER_STATE.PLAYER, #BLUE
	GameInfo.PLAYER_STATE.PLAYER, #BLACK
	GameInfo.PLAYER_STATE.PLAYER, #GREEN
	GameInfo.PLAYER_STATE.PLAYER, #ORANGE
	GameInfo.PLAYER_STATE.PLAYER, #YELLOW
	GameInfo.PLAYER_STATE.PLAYER, #WHITE
]

func _ready():
	Log.add_log_msg("Player Selection Screen loaded.")

func _on_BackButton_pressed():
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")

func _on_StartGameButton_pressed():
	var count = 0
	for player in players:
		if player != 2:
			count += 1
	GameInfo.PLAYER_COUNT = count
	get_tree().change_scene("res://Scenes/Main.tscn")

func changePlayerState(index, state):
	players[index] = state
	print(players)
	
