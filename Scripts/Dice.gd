extends Node

func _ready():
	pass # Replace with function body.

func showDice(value):
	print(value)
	if value == 1:
		print("one")
#		$One.popup()
		$One.show()
#		$One.visible = True
		print($One.is_visible_in_tree())
	elif value == 2:
		print("two")
#		$Two.popup()
		$Two.show()
#		$Two.visible = true
		print($Two.is_visible_in_tree())
	elif value == 3:
		print("three")
#		$Three.popup()
		$Three.show()
#		$Three.visible = true
		print($Three.is_visible_in_tree())
	elif value == 4:
		print("four")
#		$Four.visible = true
		$Four.show()
		print($Four.is_visible_in_tree())
	elif value == 5:
		print("five")
#		$Five.visible = true
		$Five.show()
		print($Five.is_visible_in_tree())
	else:
		print("six")
#		$Six.visible = true
		$Six.show()
		print($Six.is_visible_in_tree())

func showOneDice():
	$One.show()
	pass

func showTwoDice():
	$Two.show()
	pass
	
func showThreeDice():
	$Three.show()
	pass
	
func showFourDice():
	$Four.show()
	pass
	
func showFiveDice():
	$Five.show()
	pass
	
func showSixDice():
	$Six.show()
	pass
