extends WindowDialog

var card_scene = preload("res://Scenes/Card.tscn")
var card_scenes = []
var player_index = 0
var cards_infantary_trade_index = 0
var cards_infantary_trade = [4, 6, 8, 10, 12, 15]
var cards_infantary_trade_amount = 0
var first_init_cards = false
onready var Main = get_node("/root/Main")
func _ready():
	pass # Replace with function body.


func _on_Button_pressed():
	init_cards(player_index)
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
			card_scene_instance.image = "res://Resources/" + territory.shape + ".png"
			if territory.player_card_owner_index == territory.player_owner_index:
				card_scene_instance.plus_two_infantry = true
			$GridContainer.add_child(card_scene_instance)
			card_scenes.append(card_scene_instance)
	var trade_available = Main.current_state == GameInfo.GAME_STATES.TRADING_TERRITORY_CARDS and can_trade_cards()
	set_trade_button_and_checkboxes_visibility(trade_available)

func print_cards(cards=card_scenes):
	var card_strings = []
	for card in cards:
		card_strings.append("Territory: %s; Shape: %s" % [card.territory_text, card.shape_text])
	return

func has_to_trade_cards():
	return len(card_scenes) >= 5

func can_trade_cards():
	if len(card_scenes) < 3:
		return false
	var triangles = []
	var circles = []
	var rectangles = []
	for card in card_scenes:
		if card.shape_text == "triangle":
			triangles.append(card)
		if card.shape_text == "circle":
			circles.append(card)
		if card.shape_text == "rectangle":
			rectangles.append(card)
	if len(triangles) >= 1 and len(circles) >= 1 and len(rectangles) >= 1:
		return true
	if len(triangles) >= 3 or len(circles) >= 3 or len(rectangles) >= 3:
		return true

func _on_TradeCardsButton_pressed():	
	var selected_cards = []
	var shapes = []
	for card in card_scenes:
		if card.selected:
			selected_cards.append(card)
			if not shapes.has(card.shape_text):
				shapes.append(card.shape_text)
	if len(selected_cards) == 3 and len(shapes) != 2:
		trade_cards(selected_cards)
		card_scenes = subtract_list(card_scenes, selected_cards)
		for card in selected_cards:
			card.queue_free()
		set_trade_button_and_checkboxes_visibility(false)
	else:
		pass
	
func subtract_list(l1, l2):
	var l3 = []
	for i in l1:
		if not i in l2:
			l3.append(i)
	return l3

func trade_cards(selected_cards):
	if cards_infantary_trade_index > 5:
		var new_amount = cards_infantary_trade[cards_infantary_trade_index - 1] + 5
		cards_infantary_trade.append(new_amount)
	cards_infantary_trade_amount = cards_infantary_trade[cards_infantary_trade_index]
	cards_infantary_trade_index += 1
	var territories = get_tree().get_nodes_in_group("territories")
	for ter in territories:
		if ter.player_card_owner_index == player_index:
			for card in selected_cards:
				if card.territory_text == ter.name:
					if ter.player_owner_index == ter.player_card_owner_index:
						ter.infantary_count += 2
					ter.player_card_owner_index = null

func set_trade_button_and_checkboxes_visibility(is_visible):
	$TradeCardsButton.visible = is_visible
	for card in card_scenes:
		card.find_node("CheckBox").visible = is_visible
