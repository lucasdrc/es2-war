extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var card_scene = preload("res://Scenes/Card.tscn")
var player_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	init_cards(player_index)
	popup()
	

func init_cards(player_index):
	for child in $GridContainer.get_children():
		child.queue_free()
	var territories = get_tree().get_nodes_in_group("territories")
	for territory in territories:
		if territory.player_card_owner_index == player_index:
			var card_scene_instance = card_scene.instance()
			card_scene_instance.territory_text = territory.name
			card_scene_instance.shape_text = territory.shape
			$GridContainer.add_child(card_scene_instance)
			
