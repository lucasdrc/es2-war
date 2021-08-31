extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var card_scene = preload("res://Scenes/Card.tscn")
var card_scenes = []
var player_index = 0
var cards_infantary_trade_index = 0
var cards_infantary_trade_amount = [4, 6, 8, 10, 12, 15]
var first_init_cards = false
func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	#if not first_init_cards:
	init_cards(player_index)
	#	first_init_cards = true
	popup()

func init_cards(player_index):
	card_scenes = []
	for child in $GridContainer.get_children():
		child.queue_free()
	var territories = get_tree().get_nodes_in_group("territories")
	for territory in territories:
		if territory.player_card_owner_index == player_index:
			var card_scene_instance = card_scene.instance()
			card_scene_instance.territory_text = territory.name
			card_scene_instance.shape_text = territory.shape
			$GridContainer.add_child(card_scene_instance)
			card_scenes.append(card_scene_instance)
	var card_scenes_available = card_scenes != []
	set_trade_button_and_checkboxes_visibility(card_scenes_available)


func _on_TradeCardsButton_pressed():
	var selected_cards = []
	var shapes = []
	for card in card_scenes:
		if card.selected:
			selected_cards.append(card)
			if not shapes.has(card.shape_text):
				shapes.append(card.shape_text)
	print(selected_cards)
	print(shapes)
	print(cards_infantary_trade_amount)
	if len(selected_cards) == 3 and len(shapes) != 2:
		print("trade cards")
	else:
		print("do not trade cards")
	

func trade_cards():
	if cards_infantary_trade_index > 5:
		var new_amount = cards_infantary_trade_amount[cards_infantary_trade_index - 1] + 5
		cards_infantary_trade_amount.append(new_amount)
	print(cards_infantary_trade_amount[cards_infantary_trade_index])
	cards_infantary_trade_index += 1
	set_trade_button_and_checkboxes_visibility(false)

func set_trade_button_and_checkboxes_visibility(is_visible):
	$TradeCardsButton.visible = is_visible
	for card in card_scenes:
		card.find_node("CheckBox").visible = is_visible
