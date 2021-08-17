extends Control

enum PLAYER_STATE {PLAYER, IA, DISABLED}

onready var playerController : PlayerSelectionScreen = get_tree().root.find_node("PlayerSelectionScreen", true, false) as PlayerSelectionScreen
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var state = PLAYER_STATE.PLAYER
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func controlsButtons():
	match state:
		PLAYER_STATE.PLAYER:
			$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/IAButton.pressed = false
			$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/DesativadoButton.pressed = false
		
		PLAYER_STATE.IA:
			$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/PlayerSelectionButton.pressed = false
			$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/DesativadoButton.pressed = false
		
		PLAYER_STATE.DISABLED:
			$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/IAButton.pressed = false
			$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/PlayerSelectionButton.pressed = false
		
		
	

func _on_PlayerSelectionButton_pressed():
	state = PLAYER_STATE.PLAYER
	playerController.changePlayerState(get_index(), state)
	controlsButtons()

func _on_DisabledSelectionButton_pressed():
	state = PLAYER_STATE.DISABLED
	playerController.changePlayerState(get_index(), state)
	controlsButtons()
	
func _on_IaSelectionButton_pressed():
	state = PLAYER_STATE.IA
	playerController.changePlayerState(get_index(), state)
	controlsButtons()
