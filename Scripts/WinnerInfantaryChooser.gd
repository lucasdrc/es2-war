extends PopupDialog

var attacker_territory: Territory
var defeated_territory: Territory
onready var MainNode = get_node("/root/Main")

func _ready():
	$MarginContainer/VBoxContainer/HBoxContainer/Button1Infantary.disabled = false
	$MarginContainer/VBoxContainer/HBoxContainer/Button2Infantary.disabled = attacker_territory.infantary_count < 3
	$MarginContainer/VBoxContainer/HBoxContainer/Button3Infantary.disabled = attacker_territory.infantary_count < 4
	show()

func _on_ButtonInfantary_pressed(amount):
	MainNode.move_infantary_to_defeated_territory(attacker_territory, defeated_territory, amount)
	queue_free()
