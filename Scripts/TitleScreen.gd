extends Node

func _ready():
	pass 

func _on_CloseButton_pressed():
	get_tree().quit();

func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Scenes/PlayerSelectionScreen.tscn")
