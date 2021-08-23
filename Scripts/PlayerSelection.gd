extends Control

enum PLAYER_STATE {PLAYER, IA, DISABLED}

onready var playerController : PlayerSelectionScreen = get_tree().root.find_node("PlayerSelectionScreen", true, false) as PlayerSelectionScreen

var state = PLAYER_STATE.PLAYER

func _ready():
	pass

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
	if state == PLAYER_STATE.PLAYER:
		$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/PlayerSelectionButton.pressed = true
		pass
	state = PLAYER_STATE.PLAYER
	playerController.changePlayerState(get_index(), state)
	controlsButtons()

func _on_DisabledSelectionButton_pressed():
	if state == PLAYER_STATE.DISABLED:
		$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/DesativadoButton.pressed = true
		pass
	state = PLAYER_STATE.DISABLED
	playerController.changePlayerState(get_index(), state)
	controlsButtons()

func _on_IaSelectionButton_pressed():
	if state == PLAYER_STATE.IA:
		$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/IAButton.pressed = true
		pass
	state = PLAYER_STATE.IA
	playerController.changePlayerState(get_index(), state)
	controlsButtons()
