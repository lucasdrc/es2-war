extends Node

func _ready():
	$Menu/Center_Row/OutlineWinnerShowcase/WinnerShowcase/ColorRect/VBoxContainer/Outline/WinnerColor.color = GameInfo.WINNER_COLOR
	$Menu/Center_Row/OutlineWinnerShowcase/WinnerShowcase/ColorRect/VBoxContainer/Outline/WinnerColor/CenterContainer/WinnerName.text = GameInfo.WINNER

func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Scenes/PlayerSelectionScreen.tscn")
