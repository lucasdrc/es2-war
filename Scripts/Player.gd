extends Node2D

var COLORS = [
	{"color": Color.red, "name": "RED"},
	{"color": Color.green, "name": "GREEN"},
	{"color": Color.blue, "name": "BLUE"},
	{"color": Color.orange, "name": "ORANGE"},
	{"color": Color.burlywood, "name": "?"},
	{"color": Color.black, "name": "BLACK"}
]
var infantary_count = 0
var color = null
var territories = []
var util_script = load("res://Util.gd").new()

func show_number_of_infantaries_received(infantaries):
	var dialog_scene = load("res://Scenes/Dialog.tscn").instance()
	dialog_scene.get_node("DialogTextLabel").dialog_text = "Você recebeu " + str(infantaries) + " tropas!"
	add_child(dialog_scene)

func receive_infantary():
	var infantaries_received_by_number_of_territories = receive_infantary_by_number_of_territories()
	var infantaries_received_by_continens_conquered = receive_infantary_by_continents_conquered()
	var infantaries_received = infantaries_received_by_continens_conquered
	infantaries_received[""] = infantaries_received_by_number_of_territories
	return infantaries_received
	
func receive_infantary_by_number_of_territories():
	var number_territories = len(territories)
	var number_infantaries_received = number_territories/2 if (number_territories >= 6) else 3
	return number_infantaries_received

func receive_infantary_by_continents_conquered():
	var continents = get_continents_conquered_by_player()
	var infantaries = get_infantaries_received_by_continents_conquered(continents)
	return infantaries

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
	return true if(territory in self.territories) else false
		
func get_infantaries_received_by_continents_conquered(continents_conquered):
	var infataries_received = {}
	for continent in continents_conquered:
		infataries_received[continent] = util_script.infantaries_received_by_continent_conquered[continent]
	return infataries_received
