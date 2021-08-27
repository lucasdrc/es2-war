extends Node2D

class_name Player

var COLORS = [
	{"color": Color.red, "name": "RED"},
	{"color": Color.green, "name": "GREEN"},
	{"color": Color.blue, "name": "BLUE"},
	{"color": Color.orange, "name": "ORANGE"},
	{"color": Color.burlywood, "name": "CREAM"},
	{"color": Color.black, "name": "BLACK"}
]
var infantary_count = 0
var color = null
var util_script = load("res://Scripts/Util.gd").new()
var selected_territory = null

func show_number_of_infantaries_received(infantaries):
	var dialog_scene = load("res://Scenes/Dialog.tscn").instance()
	dialog_scene.get_node("DialogTextLabel").dialog_text = "Você recebeu " + str(infantaries) + " tropas!"
	add_child(dialog_scene)

func receive_infantary():
	var infantaries_received_by_number_of_territories = receive_infantary_by_number_of_territories()
	var infantaries_received_by_continens_conquered = receive_infantary_by_continents_conquered()
	var infantaries_received = infantaries_received_by_continens_conquered
	infantaries_received[""] = infantaries_received_by_number_of_territories
	for i in infantaries_received:
		infantary_count += infantaries_received[i]
	show_number_of_infantaries_received(infantary_count)

func receive_infantary_by_number_of_territories():
	var number_territories = len(get_territories_conquered_by_player())
	var number_infantaries_received = number_territories/2 if (number_territories >= 6) else 3
	return number_infantaries_received

func receive_infantary_by_continents_conquered():
	var continents = get_continents_conquered_by_player()
	var infantaries = get_infantaries_received_by_continents_conquered(continents)
	return infantaries

func get_territories_conquered_by_player():
	var all_territories = get_tree().get_nodes_in_group("territories")
	var owned_territories = []
	for ter in all_territories:
		if(ter.player_owner_index == get_index()):
			owned_territories.append(ter)
	return owned_territories

func get_continents_conquered_by_player():
	var continents_conquered = []
	for continent in util_script.territories_by_continent:
		if(continent_conquered_by_player(continent)):
			continents_conquered.append(continent)
	return continents_conquered

func continent_conquered_by_player(continent):
	for territory in util_script.territories_by_continent[continent]:
		if(not territory_conquered_by_player(territory)):
			return false
	return true

func territory_conquered_by_player(territory):
	return get_tree().get_root().find_node(territory, true, false).player_owner_index == get_index()
		
func get_infantaries_received_by_continents_conquered(continents_conquered):
	var infataries_received = {}
	for continent in continents_conquered:
		infataries_received[continent] = util_script.infantaries_received_by_continent_conquered[continent]
	return infataries_received
