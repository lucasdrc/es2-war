extends Control

enum PLAYER_STATE {PLAYER, IA, DISABLED}

onready var playerController : PlayerSelectionScreen = get_tree().root.find_node("PlayerSelectionScreen", true, false) as PlayerSelectionScreen

func _ready():
	pass

func _on_PlayerSelectionButton_pressed():
	$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/PlayerSelectionButton.pressed = true
	$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/IAButton.pressed = false
	$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/DesativadoButton.pressed = false
	playerController.changePlayerState(get_index(), PLAYER_STATE.PLAYER)

func _on_IaSelectionButton_pressed():
	$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/PlayerSelectionButton.pressed = false
	$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/IAButton.pressed = true
	$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/DesativadoButton.pressed = false
	playerController.changePlayerState(get_index(), PLAYER_STATE.IA)

func _on_DisabledSelectionButton_pressed():
	$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/PlayerSelectionButton.pressed = false
	$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/IAButton.pressed = false
	$Player/Color/GridContainer/Buttons/PlayerSelectionBox/Player/ColorRect/ButtonsPlayerSelection/DesativadoButton.pressed = true
	playerController.changePlayerState(get_index(), PLAYER_STATE.DISABLED)
