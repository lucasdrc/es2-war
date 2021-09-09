extends Node

func _ready():
	Log.add_log_msg("Title Screen lodaded.")

func _on_CloseButton_pressed():
	get_tree().quit();
	Log.add_log_msg("Program finished.")
	print(Log.log_msgs)

func _on_NewGameButton_pressed():
	get_tree().change_scene("res://Scenes/PlayerSelectionScreen.tscn")
