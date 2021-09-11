extends Node

var number_troops = 1
var max_troops = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass 

func confirm():
	pass

func _on_AddButton_pressed():
	if(number_troops < max_troops):
		number_troops += 1
		updateNumber()

func _on_SubtractButton_pressed():
	if(number_troops > 1):
		number_troops -= 1
		updateNumber()

func updateNumber():
	$VBoxContainer/CenterContainer/GridContainer/NumberBox/Number.text = str(number_troops)

func _on_CancelButton_pressed():
	$".".hide()
