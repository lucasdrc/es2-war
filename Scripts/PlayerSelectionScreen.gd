extends Node

class_name PlayerSelectionScreen

enum PLAYER_STATE {PLAYER, IA, DISABLED}

var players = [
	PLAYER_STATE.PLAYER, #BLUE
	PLAYER_STATE.PLAYER, #BLACK
	PLAYER_STATE.PLAYER, #GREEN
	PLAYER_STATE.DISABLED, #ORANGE
	PLAYER_STATE.DISABLED, #YELLOW
	PLAYER_STATE.DISABLED, #WHITE
]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
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
