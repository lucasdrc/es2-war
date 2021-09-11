extends Node

var rng = RandomNumberGenerator.new()
var number_troops = 1
var max_troops = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	
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

func _on_ConfirmButton_pressed():
	var dice_results = []
	for n in number_troops:
		dice_results.append(rng.randi_range(1.0, 6.0))
	print(dice_results)
	get_parent().showDicesResultDialog(dice_results)
	$".".hide()	
